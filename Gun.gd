extends RigidBody2D

export var MAX_HEALTH : float = 50
onready var health : float = MAX_HEALTH
var dead : bool = false

var map_coords : Vector2
var is_connected : bool = false
var is_connected_check : bool = false
var blocked_tile : Vector2 = Vector2(0, -1)
onready var collision_shapes = [get_node("CollisionShape2D"), get_node("CollisionShape2D2")]

onready var mGlobal = get_node("/root/Global")
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.get_button_index() == BUTTON_LEFT && event.pressed:
		mGlobal.part_picked(self)

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
	var explode = preload("res://Explosion.tscn").instance()
	get_tree().get_root().add_child(explode, true)
	explode.set_global_position(self.get_global_position())
	get_parent().remove_child(self)