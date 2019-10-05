extends RigidBody2D

#export var mass : float = 1
export var energy : float = 50.0

var map_coords : Vector2
onready var collision_shapes = [get_node("CollisionShape2D")]
