extends RigidBody2D

#export var mass : float = 1
export var storage_space : int = 50

var map_coords : Vector2
onready var collision_shapes = [get_node("CollisionShape2D")]