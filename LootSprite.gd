extends Sprite

onready var tween_values = [Color(1, 1, 1, 1), Color(0.7, 0.7, 0.7, 1)]
onready var mTween : Tween = get_node("Tween")
onready var mCollect : Tween = get_node("Collect")
onready var mColShape : CollisionShape2D = get_node("../CollisionShape2D")
onready var mSound : AudioStreamPlayer = get_node("AudioStreamPlayer")

var is_collected : bool = false

func _ready():
	self.rotation = rand_range(-PI, PI)
	_start_tween()
	pass

func _start_tween():
	mTween.interpolate_property(self, "modulate", tween_values[0], tween_values[1], rand_range(0.3, 0.5), Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	mTween.start()

func _on_Tween_tween_completed(object, key):
	tween_values.invert()
	_start_tween()

func collect() -> int:
	if is_collected:
		return 0
	is_collected = true
	mColShape.disabled = true
	var time = rand_range(0.2, 0.3)
	mSound.pitch_scale = rand_range(0.9, 1.1)
	mSound.play()
	mCollect.interpolate_property(self, "modulate", modulate, Color(100, 100, 100, 0.0), time, Tween.TRANS_EXPO, Tween.EASE_IN)
	mCollect.interpolate_property(self, "scale", scale, Vector2(4, 4), time, Tween.TRANS_EXPO, Tween.EASE_IN)
	mCollect.start()
	return 1

func _on_Collect_tween_all_completed():
	#oops
	get_parent().get_parent().remove_child(get_parent())
