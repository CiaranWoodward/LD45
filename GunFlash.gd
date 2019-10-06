extends Sprite

onready var mTween : Tween = get_node("Tween")

func flash():
	mTween.stop_all()
	mTween.interpolate_property(self, "modulate", Color(10, 10, 10, 1.0), Color(1, 1, 1, 0.0), rand_range(0.5, 0.7), Tween.TRANS_CUBIC, Tween.EASE_OUT)
	mTween.start()