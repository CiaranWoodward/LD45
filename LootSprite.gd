extends Sprite

onready var tween_values = [Color(1, 1, 1, 1), Color(0.7, 0.7, 0.7, 1)]
onready var mTween : Tween = get_node("Tween")

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
