extends Node

var game_shield
var player_core

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
func part_picked(part):
	if is_instance_valid(game_shield) && "map_coords" in part:
		game_shield.part_picked(part)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
