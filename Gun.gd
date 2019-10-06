extends RigidBody2D

export var MAX_HEALTH : float = 50
export var recoil : float = 50
onready var health : float = MAX_HEALTH
var dead : bool = false

var map_coords : Vector2
var is_connected : bool = false
var is_connected_check : bool = false
var blocked_tile : Vector2 = Vector2(0, -1)
onready var collision_shapes = [get_node("CollisionShape2D"), get_node("CollisionShape2D2")]

onready var mMuzzle = get_node("MuzzleTip")
onready var mCooldown : Timer = get_node("Cooldown")
onready var mGlobal = get_node("/root/Global")
onready var mSound : AudioStreamPlayer = get_node("GunSound")
onready var mFlash = get_node("GunFlash")

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && event.get_button_index() == BUTTON_LEFT && event.pressed:
		mGlobal.part_picked(self)

func _process(delta):
	if(!is_connected):
		return
		
	if Input.is_action_pressed("shoot") && mCooldown.is_stopped():
		mCooldown.wait_time = rand_range(0.4, 0.6)
		mCooldown.start()
		mFlash.flash()
		mSound.pitch_scale = rand_range(0.8, 1.2)
		mSound.play()
		var host_node = get_node("../..")
		var bullet = preload("res://Bullet.tscn").instance()
		get_tree().get_root().add_child(bullet)
		bullet.set_global_position(mMuzzle.get_global_position())
		var velocity = Vector2(cos(mMuzzle.get_global_rotation()), sin(mMuzzle.get_global_rotation()))
		host_node.apply_impulse(self.position, -velocity * recoil)
		velocity *= rand_range(800.0, 1000.0)
		velocity += host_node.linear_velocity
		bullet.linear_velocity = velocity

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