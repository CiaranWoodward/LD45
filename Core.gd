extends RigidBody2D

export var energy : float = 50.0

export var MAX_HEALTH : float = 50
onready var health : float = MAX_HEALTH
var dead : bool = false

var map_coords : Vector2
var is_connected : bool = true
var is_connected_check : bool = true
var always_connected : bool = true
onready var collision_shapes = [get_node("CollisionShape2D")]

func damage(damage : float, health_src : float, body_shape : int) -> float:
	health -= damage
	if health < 0:
		health = 0
	self.modulate = Color(1.0, health/MAX_HEALTH, health/MAX_HEALTH)
	if health <= 0:
		die()
		return damage - health
	return damage

func die():
	if(dead):
		return
	dead = true
	if is_connected:
		var hostcore = get_node("../..")
		hostcore.drop_part(self)
		hostcore.drop_unconnected_nodes()
		hostcore.damage(100000, 0, -1)
	var explode = preload("res://Explosion.tscn").instance()
	get_tree().get_root().add_child(explode, true)
	explode.set_global_position(self.get_global_position())
	