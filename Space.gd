extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var difficulty : float = 0

var spawnedObject = []
onready var mPlayerCore = get_node("PlayerCore")

# Initial wait before bombarding the player
var learning_countdown : int = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_CleanupCountdown_timeout():
	pass # Replace with function body.


func _on_PartsCountdown_timeout():
	print("spawned parts")
	var numParts = randi() % 3
	var spawnpoint = mPlayerCore.position
	var dirVec : Vector2
	if mPlayerCore.linear_velocity == Vector2(0,0):
		dirVec = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	else:
		dirVec = mPlayerCore.linear_velocity.normalized()
	spawnpoint += dirVec * ProjectSettings.get_setting("display/window/size/width") * 1.6
	for i in range(numParts):
		var part_type = randi() % 4
		var newPart
		match(part_type):
			0: newPart = preload("res://Thruster.tscn").instance()
			1: newPart = preload("res://Storage.tscn").instance()
			2: newPart = preload("res://Gun.tscn").instance()
			3: newPart = preload("res://Reactor.tscn").instance()
		spawnedObject.append(newPart)
		self.add_child(newPart, true)
		newPart.position = spawnpoint + Vector2(rand_range(-100, 100), rand_range(-100, 100))
		newPart.rotation = rand_range(-PI, PI)


func _on_MeteorCountdown_timeout():
	if learning_countdown > 0:
		learning_countdown -= 1
		return
	
	print("spawned meteors")
	var numMeteors = randi() % 2 + 1
	for i in range(numMeteors):
		var spawnpoint = mPlayerCore.position
		var dirVec : Vector2 = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
		spawnpoint += dirVec * ProjectSettings.get_setting("display/window/size/width") * 1.4
		var metType = randi() % 2
		var newMet
		match(metType):
			0: newMet = preload("res://Meteor1.tscn").instance()
			1: newMet = preload("res://Meteor2.tscn").instance()
		spawnedObject.append(newMet)
		newMet.position = spawnpoint + Vector2(rand_range(-200, 200), rand_range(-200, 200))
		self.add_child(newMet, true)
