extends Sprite

onready var tween_values = [Color(1, 1, 1, 0.6), Color(1, 1, 1, 0.9)]
onready var mTween : Tween = get_node("Tween")
onready var mParticles : Particles2D = get_node("Particles2D")

func _ready():
	pass

func _start_tween():
	mTween.interpolate_property(self, "modulate", tween_values[0], tween_values[1], rand_range(0.5, 0.9), Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	mTween.start()

func _on_tween_completed(object, key):
	if(!get_parent().is_connected):
		return

	if Input.is_action_pressed("thrust"):
		tween_values.invert()
		_start_tween()

func _process(delta):
	if(!get_parent().is_connected):
		return

	if Input.is_action_just_pressed("thrust"):
		mTween.stop_all()
		mTween.interpolate_property(self, "modulate", self.modulate, tween_values[1], rand_range(0.2, 0.4), Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		mTween.start()
		mParticles.emitting = true
	elif Input.is_action_just_released("thrust"):
		mTween.stop_all()
		mTween.interpolate_property(self, "modulate", self.modulate, Color(1, 1, 1, 0), rand_range(0.2, 0.4), Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		mTween.start()
		mParticles.emitting = false