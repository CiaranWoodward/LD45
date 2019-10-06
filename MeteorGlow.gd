extends Sprite

onready var tween_values = [Color(1, 1, 1, 0.2), Color(1, 1, 1, 0.9)]
onready var mTween : Tween = get_node("Tween")

func _ready():
	_start_tween()
	pass

func _start_tween():
	mTween.interpolate_property(self, "modulate", tween_values[0], tween_values[1], rand_range(0.3, 0.5), Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	mTween.start()

func _on_tween_completed(object, key):
	tween_values.invert()
	_start_tween()