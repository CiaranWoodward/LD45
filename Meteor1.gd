extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var mGlobal = get_node("/root/Global")

# Called when the node enters the scene tree for the first time.
func _ready():
	self.angular_velocity = rand_range(-2, 2)
	var dir_to_player = self.get_global_position().direction_to(mGlobal.player_core.get_global_position())
	self.linear_velocity = (dir_to_player * rand_range(200, 270)) + Vector2(rand_range(-20, 20), rand_range(-20, 20))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
