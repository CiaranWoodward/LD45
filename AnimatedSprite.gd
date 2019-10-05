extends AnimatedSprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var frame_no : int = randi() % frames.get_frame_count("stars")
	set_frame(frame_no)
	print(frame_no)
	
	var opacity : float = rand_range(0.1, 0.5)
	modulate = Color(1, 1, 1, opacity)
	print(opacity)
