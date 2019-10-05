extends KinematicBody2D

const ROTATIONAL_POWER : float = 0.005
const ROTATIONAL_MAX_SPEED : float = 0.1
const ROTATIONAL_DECAY : float = 0.95

# Tile map
onready var mTileMap : TileMap = get_node("TileMap")

# angular momentum
var rotational_speed : float= 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var targetCoords = mTileMap.map_to_world(Vector2(0, 1))
	var thruster = preload("res://Thruster.tscn").instance()
	thruster.set_global_position(targetCoords)
	mTileMap.add_child(thruster, true)
	pass

# Called every tick at a constant rate. 'delta' is the elapsed time since the previous tick (fixed).
func _physics_process(delta : float):
	# Handle input
	if Input.is_action_pressed("rot_left") and not Input.is_action_pressed("rot_right"):
		rotational_speed -= ROTATIONAL_POWER
	elif Input.is_action_pressed("rot_right") and not Input.is_action_pressed("rot_left"):
		rotational_speed += ROTATIONAL_POWER
	else:
		rotational_speed *= ROTATIONAL_DECAY
	
	# Restrict max speed
	if rotational_speed > ROTATIONAL_MAX_SPEED:
		rotational_speed = ROTATIONAL_MAX_SPEED
	elif rotational_speed < -ROTATIONAL_MAX_SPEED:
		rotational_speed = -ROTATIONAL_MAX_SPEED
	
	# Apply rotation
	rotate(rotational_speed)
