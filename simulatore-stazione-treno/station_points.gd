extends Node2D
class_name StationPoints

var intermadiatePoint : Dictionary

func getintermediatePoint() -> Dictionary:
		intermadiatePoint.clear()
		for child in get_children():
			if child is Line2D && child.name.to_lower().begins_with('punto'):
				var a = child.get_global_transform()
				
				intermadiatePoint.set(child.name, a*child.points[0])
				
		return intermadiatePoint
			
	



















## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
