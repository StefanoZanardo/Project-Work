extends Node2D 
@export var speed : float = 200.0
@export var line_2d : NodePath
@export var rail_ : RailSegment
var line_node : Line2D
var rail_point : PackedVector2Array
var current_point_index : int = 0
var crossroad : PackedVector2Array 
var activepath : PackedVector2Array
var isCrossRoad : bool
var c : int = 0



func _ready():
	if rail_ != null:
		print(rail_.get_global_points())
	rail_point = rail_.get_global_points()
	print(rail_point)
	

	
	global_position = rail_point[0]
	current_point_index = 1
	activepath = rail_point
	isCrossRoad = false
	
	
	
	
func _physics_process(delta: float) -> void:
	
	if current_point_index < activepath.size():
		var target_point:Vector2 = activepath[current_point_index]
		var direction: Vector2 = (target_point - global_position).normalized()
		var distance_to_travel : float = delta * speed
		var distance_to_target_point : float = global_position.distance_to(target_point)
		if distance_to_travel >= distance_to_target_point:
			_filter_points()
			print(activepath)
			global_position = target_point
			#current_point_index += 1
			if current_point_index >= activepath.size():
				set_physics_process(false)
		else:
			print(direction)
			print(distance_to_travel)
			global_position += direction*distance_to_travel
			rotation = direction.angle()
		
func _switch_process() -> bool:
	return abs(global_position.y - crossroad[0].y) < 2.0	
	
func _filter_points() -> void:
	var new_path = PackedVector2Array()
	var near : int = 55
	for punto in activepath:
		if (punto.y-global_position.y) < 55 and (punto.x-global_position.x) > 10:
			new_path.append(punto)
	

	activepath = new_path
	current_point_index = 0
