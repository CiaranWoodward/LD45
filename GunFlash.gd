extends Sprite

onready var mTween : Tween = get_node("Tween")

func _process(delta):
	if(!get_parent().is_connected):
		return
		
	if Input.is_action_just_pressed("shoot"):
		mTween.stop_all()
		mTween.interpolate_property(self, "modulate", Color(10, 10, 10, 1.0), Color(1, 1, 1, 0.0), rand_range(0.5, 0.7), Tween.TRANS_CUBIC, Tween.EASE_OUT)
		mTween.start()