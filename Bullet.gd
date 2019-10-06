extends RigidBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var mGlobal = get_node("/root/Global")
onready var mTimer = get_node("Timer")
export var MAX_HEALTH : float = 50

onready var health : float = MAX_HEALTH
var dead : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.angular_velocity = rand_range(-2, 2)
	var dir_to_player = self.get_global_position().direction_to(mGlobal.player_core.get_global_position())
	self.linear_velocity = (dir_to_player * rand_range(200, 270)) + Vector2(rand_range(-20, 20), rand_range(-20, 20))
	self.connect("body_shape_entered", self, "body_collided")
	mTimer.start()

func body_collided(body_id : int, body : Node, body_shape : int, local_shape : int ):
	print("collision detected " + str(body_id) + " - " + body.name + " - " + str(body_shape) + " : " + str(local_shape))
	var collision_speed : float
	if "linear_velocity" in body:
		collision_speed = (self.linear_velocity - body.linear_velocity).length()
	else:
		collision_speed = self.linear_velocity.length()
	var damage = collision_speed
	var damage_received = damage
	print("collision damage = " + str(damage))
	if body.has_method("damage"):
		damage_received = body.damage(damage, health, body_shape)
	health -= damage_received
	if health < 0:
		die()

func damage(damage : float, health_src : float, shape_no : int) -> float:
	health -= damage
	if health < 0:
		die()
		return damage - health
	return damage

func die():
	if(dead):
		return
	dead = true
	var explode = preload("res://Explosion.tscn").instance()
	get_tree().get_root().add_child(explode, true)
	explode.set_global_position(self.get_global_position())
	get_parent().remove_child(self)

func _on_Timer_timeout():
	get_parent().remove_child(self)
