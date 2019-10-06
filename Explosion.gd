extends Node2D

onready var p1 : Particles2D = get_node("Particles2D")
onready var p2 : Particles2D = get_node("Particles2D2")
onready var a1 : AudioStreamPlayer = get_node("AudioStreamPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	p1.emitting = true
	p2.emitting = true
	a1.pitch_scale = rand_range(0.9, 1.1)
	a1.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!p1.emitting && !p2.emitting && !a1.playing):
		get_parent().remove_child(self)
