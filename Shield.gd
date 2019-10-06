extends StaticBody2D
class_name Shield

enum {MODE_SHIELD, MODE_BUILD}

const SHIELD_THICKNESS = 30

onready var col_pol : CollisionPolygon2D = get_node("ColPol")

var power_in : float = 100.0
var current_power : float = 0
var radius : float = 45.0
var seg_count : int = 0
var angle_span : float = 0
var cur_mode = MODE_SHIELD

var cur_part : Object = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cur_mode == MODE_SHIELD:
		process_shield(delta)
	else:
		process_build(delta)
	
func process_build(delta):
	self.set_global_position(self.get_global_mouse_position())
	self.rotation = 0
	
	if cur_part != null && !Input.is_mouse_button_pressed(BUTTON_LEFT):
		drop_part()
	
	if current_power < power_in:
		current_power += power_in * delta * 0.2
		
	if current_power > power_in:
		current_power = power_in
	
	angle_span = 200 * current_power
	
	if angle_span > 360:
		angle_span = 360
	
	#Check if we have to redraw, we only draw in units of 10 degrees
	var n_seg_count = range(0, angle_span, 10).size()
	if n_seg_count != seg_count:
		seg_count = n_seg_count
		angle_span = n_seg_count * 10.0
		update() # trigger a redraw
	
func process_shield(delta):
	var angle = self.get_angle_to(self.get_global_mouse_position())
	self.rotate(angle)
	
	if current_power < power_in:
		current_power += power_in * delta * 0.2
		
	if current_power > power_in:
		current_power = power_in
	
	angle_span = 200 * current_power / radius
	
	if angle_span > 360:
		angle_span = 360
	
	#Check if we have to redraw, we only draw in units of 10 degrees
	var n_seg_count = range(0, angle_span, 10).size()
	if n_seg_count != seg_count:
		seg_count = n_seg_count
		angle_span = n_seg_count * 10.0
		update() # trigger a redraw

func _draw():
	var angle_center = 90
	seg_count = range(0, angle_span, 10).size()
	
	var angle_from = angle_center - (angle_span/2)
	var angle_to = angle_center + (angle_span/2)
	
	build_collision_mesh(angle_from, angle_to)
	for ang in range(angle_from, angle_to, 10):
		draw_circle_arc_thick(ang, ang+10)

func draw_circle_arc_thick(angle_from, angle_to):
	var nb_points = 2
	var points_arc = PoolVector2Array()
	var color_array = []

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * radius)
		color_array.push_back(Color(1.0, 1.0, 1.0, 1.0))
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_to + i * (angle_from - angle_to) / nb_points - 90)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * (radius - SHIELD_THICKNESS))
		color_array.push_back(Color(1.0, 1.0, 1.0, 0.1))
		
	var colors = PoolColorArray(color_array)
	draw_polygon(points_arc, colors)

func build_collision_mesh(angle_from, angle_to):
	var nb_points = ceil((angle_to - angle_from)/20)
	var points_arc = PoolVector2Array()
	
	if nb_points == 0:
		col_pol.polygon = PoolVector2Array()
		return

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * radius)
	
	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_to + i * (angle_from - angle_to) / nb_points - 90)
		points_arc.push_back(Vector2(cos(angle_point), sin(angle_point)) * (radius - SHIELD_THICKNESS))
	
	col_pol.polygon = points_arc

func set_shield_params(radius : float, power : float):
	if cur_mode == MODE_SHIELD:
		self.radius = radius
		self.power_in = power
		update()
	
func set_shield_mode(mode):
	if mode == MODE_SHIELD:
		cur_mode = MODE_SHIELD
		self.position = Vector2(0, 0)
		self.rotation = 0
	else:
		cur_mode = MODE_BUILD
		self.set_global_position(self.get_global_mouse_position())
		radius = 64

func drop_part():
	if cur_part == null:
		return
	cur_part.mode = RigidBody2D.MODE_RIGID
	for cs in cur_part.collision_shapes:
		cs.disabled = false
	var gcoords = cur_part.get_global_position()
	self.remove_child(cur_part)
	get_tree().get_root().add_child(cur_part)
	cur_part.set_global_position(gcoords)
	cur_part = null

func part_picked(part):
	if cur_part == null && cur_mode == MODE_BUILD:
		cur_part = part
		cur_part.mode = RigidBody2D.MODE_STATIC
		# Hide collision shaped for carrying
		for cs in cur_part.collision_shapes:
			cs.disabled = true
		#Remove from old parent
		cur_part.get_parent().remove_child(cur_part)
		self.add_child(cur_part)
		cur_part.position = Vector2(0,0)
		cur_part.rotation = 0