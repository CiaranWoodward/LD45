extends RigidBody2D

export var storage_space : int = 50

var map_coords : Vector2
var is_connected : bool = false
var is_connected_check : bool = false
onready var collision_shapes = [get_node("CollisionShape2D")]