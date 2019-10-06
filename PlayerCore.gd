extends RigidBody2D

export var MAX_HEALTH : float = 150

# Root node for building
onready var mRootNode : Node2D = get_node("RootNode")
onready var mShield : Shield = get_node("RootNode/Shield")
onready var mGlobal = get_node("/root/Global")
var mCore

var is_connected : bool = true
var is_connected_check : bool = true
var always_connected : bool = true
var map_coords : Vector2 = Vector2(0, 0)

var thrust_power : float = 0.0
var rotational_power : float = 100.0
var storage_space : int = 50

onready var health : float = MAX_HEALTH
var dead : bool 

var build_mode : bool = false
var connected_tiles = {Vector2(0, 0): self, Vector2(0, -1): self}
var blocked_tiles = []

# Called when the node enters the scene tree for the first time.
func _ready():
	mCore = preload("res://Core.tscn").instance()
	add_part(mCore, Vector2(0, 1))
	mGlobal.game_shield = mShield
	mGlobal.player_core = self

func _process(delta):
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
		
	#Blocked tile is filled
	if "blocked_tile" in part && connected_tiles.has(mapCoords + part.blocked_tile):
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

func mouse_to_tilepos() -> Vector2:
	var mousepos : Vector2 = self.get_local_mouse_position()
	mousepos.x += 32
	mousepos = mousepos / 64
	mousepos = mousepos.floor()
	return mousepos

func can_add_part_at_mouse(part) -> bool:
	var mousepos : Vector2 = self.mouse_to_tilepos()
	if can_add_part(part, mousepos):
		return true
	return false

func add_part_at_mouse(part) -> bool:
	var mousepos : Vector2 = self.mouse_to_tilepos()
	if can_add_part(part, mousepos):
		add_part(part, mousepos)
		return true
	return false

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

func drop_part(part):
	var mapCoords = part.map_coords
	if "mass" in part:
		self.mass -= part.mass
	if "thrust" in part:
		self.thrust_power -= part.thrust
	if "rotational_power" in part:
		self.rotational_power -= part.rotational_power
	if "storage_space" in part:
		self.storage_space -= part.storage_space
	if "is_connected" in part:
		part.is_connected = false
	if "blocked_tile" in part:
		blocked_tiles.remove(blocked_tiles.find(part.blocked_tile + mapCoords))
	
	var gcoords = part.get_global_position()
	connected_tiles.erase(part.map_coords)
	mRootNode.remove_child(part)
	part.mode = RigidBody2D.MODE_RIGID
	get_tree().get_root().add_child(part)
	part.set_global_position(gcoords)
	
	# Relocate all of the collision shapes onto the part
	for col_shape in part.collision_shapes:
		var global_pos = col_shape.get_global_position()
		self.remove_child(col_shape)
		part.add_child(col_shape, true)
		col_shape.set_global_position(global_pos)
	
	update_shield()

func _input_event(viewport, event, shape_idx):
	if !build_mode:
		return
	if event is InputEventMouseButton && event.get_button_index() == BUTTON_LEFT && event.pressed:
		var tilepos = mouse_to_tilepos()
		if connected_tiles.has(tilepos):
			var part = connected_tiles[tilepos]
			if "always_connected" in part && part.always_connected:
				return
			drop_part(part)
			drop_unconnected_nodes()
			mShield.part_picked(part)

func update_shield():
	var shield_radius = get_furthest_part()
	mShield.set_shield_params(shield_radius, 100)

func drop_unconnected_nodes():
	#First set all of the is_connected_check values to false
	for N in mRootNode.get_children():
		if "is_connected_check" in N:
			N.is_connected_check = false
	
	#Mark connection from Core & 2 cockpit tiles
	mark_connected_neighbors(mCore, mCore.map_coords)
	self.is_connected_check = false
	mark_connected_neighbors(self, Vector2(0, 0))
	self.is_connected_check = false
	mark_connected_neighbors(self, Vector2(0, -1))
	
	#Drop all unconnected nodes
	var drop_these = []
	for N in mRootNode.get_children():
		if "is_connected_check" in N && !N.is_connected_check:
			drop_these.append(N)
	for N in drop_these:
		drop_part(N)

func mark_connected_neighbors(part, coords):
	if part.is_connected_check:
		return #Already processed
	
	part.is_connected_check = true
	var direction = Vector2(1, 0)
	for i in range(4):
		var coords_next = part.map_coords + direction
		if connected_tiles.has(coords_next):
			var target = connected_tiles[coords_next]
			mark_connected_neighbors(target, coords_next)
		direction = direction.rotated(PI/2).round()

func get_furthest_part() -> float:
	var furthestPart : float = 0.0
	for N in mRootNode.get_children():
		if "map_coords" in N:
			var length : float = N.map_coords.length()
			if length > furthestPart:
				furthestPart = length
	return (furthestPart + 1.5) * 64

func damage(damage : float, health_src : float, body_shape : int) -> float:
	var id_count : int = 0
	for ch in self.get_children():
		if ch is CollisionShape2D:
			if body_shape == id_count:
				if "original_parent" in ch:
					return ch.original_parent.damage(damage, health_src, 0)
				break
			id_count += 1
	
	health -= damage
	if health < 0:
		die()
		return damage - health
	return damage

func die():
	print("Game over")