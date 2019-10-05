extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var mThrustFlame : Sprite = get_node("ThrustFlame")

# Called when the node enters the scene tree for the first time.
func _ready():
	mThrustFlame.visible = false
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(Input.is_action_pressed("thrust")):
		mThrustFlame.visible = true
	else:
		mThrustFlame.visible = false
