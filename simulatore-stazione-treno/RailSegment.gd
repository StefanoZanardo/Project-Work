extends Node2D
class_name RailSegment
@export var line_path: NodePath
var line_node: Line2D
var points_global: PackedVector2Array = []

func _ready():
	if line_path:
		line_node = get_node(line_path)
	else:
		line_node = $Line2D  
	points_global = line_node.get_global_transform() * line_node.points
	print(points_global)


func get_global_points() -> PackedVector2Array:
	return line_node.get_global_transform() * line_node.points
