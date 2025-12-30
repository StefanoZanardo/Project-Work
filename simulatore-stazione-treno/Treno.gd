extends Node2D 
@export var speed : float = 200.0
@export var line_2d : NodePath
@export var rail_ : RailSegment
var line_node : Line2D
var rail_point : PackedVector2Array
var current_point_index : int = 0
var crossroadPoints : PackedVector2Array 
var railPoints : BinarioInfo
var activepath : PackedVector2Array
var ChangeLaneRail : bool
var ActualCrossRoad : PackedVector2Array
var foward : bool



func _ready():

		
	railPoints = rail_.get_global_points()
	
	crossroadPoints = railPoints.crossroad
	rail_point = railPoints.rail_segment
	#Questo è hard coded poi dovrà essre messo dinamicamente 
	ChangeLaneRail = true
	#Anche questo è hardcoded
	foward = true
	
	

	
	global_position = rail_point[0]
	current_point_index = 1
	activepath = rail_point
	#Qua quello che facciamo è dire al nostro treno qual è la nostra crossroad attuale
	ActualCrossRoad = _actual_crossroadpoint(crossroadPoints)
	
	print(ActualCrossRoad)

	



	
	
	
func _physics_process(delta: float) -> void:
	
	if current_point_index < activepath.size():
		var target_point:Vector2 = activepath[current_point_index]
		var direction: Vector2 = (target_point - global_position).normalized()
		var distance_to_travel : float = delta * speed
		var distance_to_target_point : float = global_position.distance_to(target_point)
		if ChangeLaneRail == true && global_position.distance_to(ActualCrossRoad[0]) < 2.0:
			activepath[0] = ActualCrossRoad[0]
			activepath[1] = ActualCrossRoad[1]
			ActualCrossRoad = _actual_crossroadpoint(crossroadPoints)
		if distance_to_travel >= distance_to_target_point:
			_filter_points()
			print(activepath)
			global_position = target_point
			if current_point_index >= activepath.size():
				print(activepath)
				set_physics_process(false)
		
		
			
		else:
			print(direction)
			print(distance_to_travel)
			global_position += direction*distance_to_travel
			rotation = direction.angle()
		
	
#Funzione che toglie tutti i punti non neccessari per il treno	(Questa bisognerà rivederla in modo che si 
func _filter_points() -> void:
	var new_path = PackedVector2Array()
	var near : int = 55
	for punto in activepath:
		if (punto.y-global_position.y) < 55 and (punto.x-global_position.x) > 10:
			new_path.append(punto)
	activepath = new_path
	current_point_index = 0
#Questa funzione ritorna la crossroad che dovrà fare 
func _actual_crossroadpoint(list_crossroad : PackedVector2Array) -> PackedVector2Array:
	var _crossroadP : PackedVector2Array = [Vector2(9999,9999), Vector2(9999,9999)]
	for i in range (list_crossroad.size()-1):
		if (list_crossroad[i].x - global_position.x) > 5.0 && abs((list_crossroad[i].y - global_position.y)) < 5.0:
			if _crossroadP[0] > list_crossroad[i]:
				if foward == true:
					_crossroadP=[list_crossroad[i], list_crossroad[i+1]]
				else:
					_crossroadP=[list_crossroad[i], list_crossroad[i-1]]
	return _crossroadP
	
#func _addNewPath
	
