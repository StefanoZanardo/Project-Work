extends Node2D 
@export var speed : float = 200.0
@export var line_2d : NodePath
@export var rail_ : RailSegment
var line_node : Line2D
var rail_point : PackedVector2Array
var current_point_index : int = 0
@onready var linea: Line2D = get_node("../CrossRoad/BivioLinea")
var crossroad : PackedVector2Array 
var activepath : PackedVector2Array
var isCrossRoad : bool
var c : int = 0



func _ready():
	if line_2d:
		line_node = get_node(line_2d)
	
	rail_point = line_node.get_global_transform()*line_node.points
	print(rail_point)
	

	
	global_position = rail_point[0]
	current_point_index = 1
	crossroad = linea.get_global_transform()*linea.points
	activepath = rail_point
	isCrossRoad = false
	
	
func _physics_process(delta: float) -> void:
	if _switch_process() and not isCrossRoad:
		activepath = crossroad
		current_point_index = 0
		isCrossRoad = true
	
	if current_point_index < activepath.size():
		var target_point:Vector2 = activepath[current_point_index]
		var direction: Vector2 = (target_point - global_position).normalized()
		var distance_to_travel : float = delta * speed
		var distance_to_target_point : float = global_position.distance_to(target_point)
		if distance_to_travel >= distance_to_target_point:
			global_position = target_point
			current_point_index += 1
			c = c + 1
			if c == 2:
				rail_point.remove_at(0)
				current_point_index = 0
				activepath = rail_point
				activepath[0].y += 50
				print(activepath)	
				print("a")
			if current_point_index >= activepath.size():
				set_physics_process(false)
		else:
			print(direction)
			print(distance_to_travel)
			global_position += direction*distance_to_travel
			rotation = direction.angle()
		
func _switch_process() -> bool:
	return abs(global_position.y - crossroad[0].y) < 2.0	
		
