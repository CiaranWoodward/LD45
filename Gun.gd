extends RigidBody2D

var map_coords : Vector2
var is_connected : bool = false
var is_connected_check : bool = false
onready var collision_shapes = [get_node("CollisionShape2D"), get_node("CollisionShape2D2")]