extends Area2D

export var mass : float = 1
export var thrust : float = 3
export var rotational_power : float = 15

var map_coords : Vector2
onready var collision_shapes = [get_node("CollisionShape2D")]