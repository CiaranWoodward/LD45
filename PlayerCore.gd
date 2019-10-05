extends RigidBody2D

# Tile map
onready var mRootNode : Node2D = get_node("RootNode")
onready var mShield : Shield = get_node("RootNode/Shield")

var thrust_power : float = 0.0
var rotational_power : float = 100.0
var storage_space : int = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	var thruster = preload("res://Thruster.tscn").instance()
	var thruster2 = preload("res://Thruster.tscn").instance()
	var storage = preload("res://Storage.tscn").instance()
	var gun = preload("res://Gun.tscn").instance()
	add_part(thruster, Vector2(0, 1))
	add_part(gun, Vector2(-1, 1))
	add_part(thruster2, Vector2(-1, 2))
	add_part(storage, Vector2(1, 1))
	add_part(preload("res://Storage.tscn").instance(), Vector2(0, -2))
	add_part(preload("res://Thruster.tscn").instance(), Vector2(1, 2))

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
	part.map_coords = mapCoords
		
	part.set_global_position(targetCoords)
	mRootNode.add_child(part, true)
	part.mode = RigidBody2D.MODE_STATIC
	
	# Relocate all of the collision shapes onto the player ship
	for col_shape in part.collision_shapes:
		var global_pos = col_shape.get_global_position()
		part.remove_child(col_shape)
		self.add_child(col_shape, true)
		col_shape.set_global_position(global_pos)
	
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