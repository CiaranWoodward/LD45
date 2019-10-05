extends Sprite

onready var tween_values = [Color(1, 1, 1, 0.5), Color(1, 1, 1, 1)]
onready var mTween : Tween = get_node("Tween")

func _ready():
	_start_tween()
	pass

func _start_tween():
	mTween.interpolate_property(self, "modulate", tween_values[0], tween_values[1], 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	mTween.start()

func _on_tween_completed(object, key):
	tween_values.invert()
	_start_tween()