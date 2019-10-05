extends RigidBody2D

const ROTATIONAL_POWER : float = 100.0
const ROTATIONAL_MAX_SPEED : float = 0.02
const ROTATIONAL_DECAY : float = 0.95

# Tile map
onready var mTileMap : TileMap = get_node("TileMap")

# angular momentum
var rotational_speed : float= 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var thruster = preload("res://Thruster.tscn").instance()
	add_part(thruster, Vector2(0, 1))

# Called every tick at a constant rate. 'delta' is the elapsed time since the previous tick (fixed).
func _physics_process(delta : float):
	# Handle input
	if Input.is_action_pressed("rot_left"):
		apply_torque_impulse(-ROTATIONAL_POWER)
	
	if Input.is_action_pressed("rot_right"):
		apply_torque_impulse(ROTATIONAL_POWER)
		
	if Input.is_action_pressed("thrust"):
		var globalthrust = global_transform.basis_xform(Vector2(0.0, -5.0))
		apply_central_impulse(globalthrust)
	

func add_part(part, mapCoords : Vector2) -> void:
	var targetCoords = mTileMap.map_to_world(mapCoords)
	part.set_global_position(targetCoords)
	mTileMap.add_child(part, true)