extends Node2D

onready var p1 : Particles2D = get_node("Particles2D")
onready var p2 : Particles2D = get_node("Particles2D2")

# Called when the node enters the scene tree for the first time.
func _ready():
	p1.emitting = true
	p2.emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!p1.emitting && !p2.emitting):
		get_parent().remove_child(self)
