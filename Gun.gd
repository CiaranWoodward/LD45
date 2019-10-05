extends Area2D

export var mass : float = 1

var map_coords : Vector2
onready var collision_shapes = [get_node("CollisionShape2D"), get_node("CollisionShape2D2")]