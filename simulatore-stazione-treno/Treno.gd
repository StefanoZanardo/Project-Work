extends Node2D 
@export var speed : float = 200.0
@export var line_2d : NodePath
var line_node : Line2D
var rail_point : PackedVector2Array
var current_point_index : int = 0



func _ready():
	if line_2d:
		line_node = get_node(line_2d)
	
	rail_point = line_node.get_global_transform()*line_node.points
	print(rail_point)
	
	global_position = rail_point[0]
	current_point_index = 1
	
func _physics_process(delta: float) -> void:
	if current_point_index < rail_point.size():
		var target_point:Vector2 = rail_point[current_point_index]
		var direction: Vector2 = (target_point - global_position).normalized()
		var distance_to_travel : float = delta * speed
		var distance_to_target_point : float = global_position.distance_to(target_point)
		if distance_to_travel >= distance_to_target_point:
			global_position = target_point
			current_point_index += 1
			if current_point_index > rail_point.size():
				set_process(false)
		else:
			print(direction)
			print(distance_to_travel)
			global_position += direction*distance_to_travel
			rotation = direction.angle()
			
		
