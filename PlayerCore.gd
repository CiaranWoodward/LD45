extends RigidBody2D

# Tile map
onready var mTileMap : TileMap = get_node("TileMap")

var thrust_power : float = 0.0
var rotational_power : float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var thruster = preload("res://Thruster.tscn").instance()
	var thruster2 = preload("res://Thruster.tscn").instance()
	var gun = preload("res://Gun.tscn").instance()
	add_part(thruster, Vector2(0, 1))
	add_part(gun, Vector2(-1, 0))
	add_part(thruster2, Vector2(-1, 1))

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
	var targetCoords = mTileMap.map_to_world(mapCoords)
	if "mass" in part:
		self.mass += part.mass
	if "thrust" in part:
		self.thrust_power += part.thrust
	if "rotational_power" in part:
		self.rotational_power += part.rotational_power
		
	part.set_global_position(targetCoords)
	mTileMap.add_child(part, true)