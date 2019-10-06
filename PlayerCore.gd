extends RigidBody2D

# Root node for building
onready var mRootNode : Node2D = get_node("RootNode")
onready var mShield : Shield = get_node("RootNode/Shield")

var is_connected : bool = true
var is_connected_check : bool = true

var thrust_power : float = 0.0
var rotational_power : float = 100.0
var storage_space : int = 50

var build_mode : bool = false
var connected_tiles = {Vector2(0, 0): self, Vector2(0, -1): self}
var blocked_tiles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	add_part(preload("res://Core.tscn").instance(), Vector2(0, 1))

func _process(delta):
	if Input.is_action_just_pressed("item_select"):
		var mousepos : Vector2 = self.get_local_mouse_position()
		var part = preload("res://Storage.tscn").instance()
		mousepos.x += 32
		mousepos = mousepos / 64
		mousepos.x = floor(mousepos.x)
		mousepos.y = floor(mousepos.y)
		if can_add_part(part, mousepos):
			add_part(part, mousepos)
	
	if Input.is_action_just_pressed("toggle_build"):
		if build_mode:
			mShield.current_power = 0
			build_mode = false
			mShield.set_shield_mode(mShield.MODE_SHIELD)
			update_shield()
		else:
			mShield.current_power = 0
			build_mode = true
			mShield.set_shield_mode(mShield.MODE_BUILD)

# Called every tick at a constant rate. 'delta' is the elapsed time since the previous tick (fixed).
func _physics_process(delta : float):
	# Handle input
	if Input.is_action_pressed("rot_left"):
		apply_torque_impulse(-rotational_power)
	
	if Input.is_action_pressed("rot_right"):
		apply_torque_impulse(rotational_power)
		
	if Input.is_action_pressed("thrust"):
		var globalthrust = global_transform.basis_xform(Vector2(0.0, -thrust_power))
		apply_central_impulse(globalthrust)

func can_add_part(part, mapCoords : Vector2) -> bool:
	#Tile is blocked
	if mapCoords in blocked_tiles:
		return false
	
	#Tile is already connected
	if connected_tiles.has(mapCoords):
		return false
	
	#Tile has no valid neighbor
	var direction = Vector2(1, 0)
	var connected = false
	for i in range(4):
		if connected_tiles.has(mapCoords + direction):
			connected = true
			break
		direction = direction.rotated(PI/2).round()
	if !connected:
		return false
	
	return true

func add_part(part, mapCoords : Vector2) -> void:
	var targetCoords = mapCoords * 64
	if "mass" in part:
		self.mass += part.mass
	if "thrust" in part:
		self.thrust_power += part.thrust
	if "rotational_power" in part:
		self.rotational_power += part.rotational_power
	if "storage_space" in part:
		self.storage_space += part.storage_space
	if "is_connected" in part:
		part.is_connected = true
	if "blocked_tile" in part:
		blocked_tiles.append(part.blocked_tile + mapCoords)
	part.map_coords = mapCoords
	
	connected_tiles[part.map_coords] = part
	part.set_global_position(targetCoords)
	mRootNode.add_child(part, true)
	part.mode = RigidBody2D.MODE_STATIC
	
	# Relocate all of the collision shapes onto the player ship
	for col_shape in part.collision_shapes:
		var global_pos = col_shape.get_global_position()
		part.remove_child(col_shape)
		self.add_child(col_shape, true)
		col_shape.set_global_position(global_pos)
	
	update_shield()


func update_shield():
	var shield_radius = get_furthest_part()
	mShield.set_shield_params(shield_radius, 100)

func get_furthest_part() -> float:
	var furthestPart : float = 0.0
	for N in mRootNode.get_children():
		if "map_coords" in N:
			var length : float = N.map_coords.length()
			if length > furthestPart:
				furthestPart = length
	return (furthestPart + 1.5) * 64