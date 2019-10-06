extends RigidBody2D

export var thrust : float = 3
export var rotational_power : float = 15

var map_coords : Vector2
var is_connected : bool = false
var is_connected_check : bool = false
onready var collision_shapes = [get_node("CollisionShape2D")]