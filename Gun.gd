extends RigidBody2D

var map_coords : Vector2
var is_connected : bool = false
var is_connected_check : bool = false
var blocked_tile : Vector2 = Vector2(0, -1)
onready var collision_shapes = [get_node("CollisionShape2D"), get_node("CollisionShape2D2")]

onready var mGlobal = get_node("/root/Global")
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.get_button_index() == BUTTON_LEFT && event.pressed:
		mGlobal.part_picked(self)