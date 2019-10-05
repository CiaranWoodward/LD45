extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const SHIELD_THICKNESS = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _draw():
	var radius = 200
	var angle_from = 0
	var angle_to = 50
	for ang in range(angle_from, angle_to, 10):
		draw_circle_arc_thick(radius, ang, ang+10)

func draw_circle_arc_thick(radius, angle_from, angle_to):
	var nb_points = 2
	var points_arc = PoolVector2Array()
	var center = self.get_position()
	var color_array = []

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
		color_array.push_back(Color(1.0, 1.0, 1.0, 1.0))
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_to + i * (angle_from - angle_to) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * (radius - SHIELD_THICKNESS))
		color_array.push_back(Color(1.0, 1.0, 1.0, 0.1))
		
	var colors = PoolColorArray(color_array)
	draw_polygon(points_arc, colors)
