extends RigidBody2D

export var energy : float = 50.0

var map_coords : Vector2
var is_connected : bool = false
var is_connected_check : bool = false
onready var collision_shapes = [get_node("CollisionShape2D")]