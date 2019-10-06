extends RigidBody2D

export var storage_space : int = 50

onready var mGlobal = get_node("/root/Global")
var map_coords : Vector2
var is_connected : bool = false
var is_connected_check : bool = false
onready var collision_shapes = [get_node("CollisionShape2D")]

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.get_button_index() == BUTTON_LEFT && event.pressed:
		mGlobal.part_picked(self)
