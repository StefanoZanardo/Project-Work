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
#Qua ho messo tutti i punti dove i treni potranno partire o arrivare
var InitialorEndPoints : Dictionary = {"L1": Vector2(-511, 210),
	"L2":Vector2(-511,260),"R1":Vector2(1575,210),"R2":Vector2(1575,260),
	"C2":Vector2(294,690),"C1":Vector2(227,708)}
#Il mio target end cioè dove deve arrivare il treno
var targetEnd : Vector2
#Questo serve per tenere conto dei punti già fatti bisognerà migliorarlo
var StoryOfPoints : PackedVector2Array


func _ready():
	
		
	railPoints = rail_.get_global_points()
	
	crossroadPoints = railPoints.crossroad
	#rail_point = railPoints.rail_segment
	
	#Questo è hard coded poi dovrà essre messo dinamicamente 
	ChangeLaneRail = false
	#Anche questo è hardcoded
	
	
	
	#Qua metto i punti di partenza e di arrivo
	
	
	global_position = InitialorEndPoints["L1"]
	targetEnd = InitialorEndPoints["C1"]
	current_point_index = 0
	foward = _isFoward(global_position, targetEnd)
	activepath.append(rail_.getBinary(global_position, targetEnd, foward))
	StoryOfPoints.append(rail_.getBinary(global_position,targetEnd, foward))
	#Qua quello che facciamo è dire al nostro treno qual è la nostra crossroad attuale
	#ActualCrossRoad = _actual_crossroadpoint(crossroadPoints)

func _physics_process(delta: float) -> void:
	
	if current_point_index <= activepath.size():
		var target_point:Vector2 = activepath[current_point_index]
		var direction: Vector2 = (target_point - global_position).normalized()
		var distance_to_travel : float = delta * speed
		var distance_to_target_point : float = global_position.distance_to(target_point)
		_isNearToCross()
		if ChangeLaneRail and StoryOfPoints[-1] != global_position :
			activepath[0]=_isNearToCross()
			StoryOfPoints.append(activepath[0])
		if distance_to_travel >= distance_to_target_point:
			activepath[0]=rail_.getBinary(global_position, targetEnd, foward)
			StoryOfPoints.append(activepath[0])
			#_filter_points()
			
			print(activepath)
			global_position = target_point
			if global_position >= targetEnd:
				print(StoryOfPoints)
				set_physics_process(false)
		
		
			
		else:
			global_position += direction*distance_to_travel
			rotation = direction.angle()
		
	
#Funzione che toglie tutti i punti non neccessari per il treno	(Questa bisognerà rivederla in modo che si 
#func _filter_points() -> void:
	#var new_path = PackedVector2Array()
	#var near : int = 55
	#for punto in activepath:
		#if abs(punto.y-global_position.y) < 55 and (punto.x-global_position.x) > 10:
			#new_path.append(punto)
	#activepath = new_path
	#current_point_index = 0
##Questa funzione ritorna la crossroad che dovrà fare 
#func _actual_crossroadpoint(list_crossroad : PackedVector2Array) -> PackedVector2Array:
	#var _crossroadP : PackedVector2Array = [Vector2(9999,9999), Vector2(9999,9999)]
	#for i in range (list_crossroad.size()-1):
		#if (list_crossroad[i].x - global_position.x) > 5.0 && abs((list_crossroad[i].y - global_position.y)) < 5.0:
			#if _crossroadP[0] > list_crossroad[i]:
				#if foward == true:
					#_crossroadP=[list_crossroad[i], list_crossroad[i+1]]
				#else:
					#_crossroadP=[list_crossroad[i], list_crossroad[i-1]]
	#return _crossroadP
#
func _isFoward(initialPos: Vector2, endPos : Vector2)->bool:
	if (initialPos.x < endPos.x):
		return true
	else:
		return false

func _isNearToCross() -> Vector2:
	var _vector : Vector2
	var trovato_scambio : bool = false
	match foward:
		true:
			for i in range(crossroadPoints.size() -1):
				if global_position.distance_to(crossroadPoints[i]) < 2.0:
					trovato_scambio = true
					_vector = rail_.getCrossRoad(global_position,targetEnd,activepath[0],crossroadPoints[i+1])
					break 
				else:
					_vector = activepath[0]
		false:
			for i in range(crossroadPoints.size() -1):
				if global_position.distance_to(crossroadPoints[i]) < 2.0:
					trovato_scambio = true
					_vector = rail_.getCrossRoad(global_position,targetEnd,activepath[0],crossroadPoints[i-1])
					break
				else:
					_vector = activepath[0]
					
	ChangeLaneRail = trovato_scambio
	return _vector
	
	
				
	
