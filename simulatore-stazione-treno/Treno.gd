extends Node2D 

@export var speed : float = 200.0
var rail_ : RailSegment 

var current_point_index : int = 0
var railPoints : BinarioInfo
var activepath : PackedVector2Array
var ChangeLaneRail : bool
var ActualCrossRoad : PackedVector2Array
var foward : bool

var InitialorEndPoints : Dictionary = {
	"L1": Vector2(-511.6, 210), "L2": Vector2(-511.6, 260),
	"R1": Vector2(1576.6, 210), "R2": Vector2(1575.6, 260),
	"C2": Vector2(294, 690), "C1": Vector2(227, 708)
}

var targetEnd : PackedVector2Array
var StoryOfPoints : PackedVector2Array
var railSegmentPoints : BinarioInfo.BinarioInfoTratti
var is_active : bool = false

func _ready():
	set_physics_process(false)

func setup_train(start_key: String, WayPoint:Vector2, end_key: String, rail_system: RailSegment):
	rail_ = rail_system 
	railPoints = await rail_.get_global_points()
	railSegmentPoints = await rail_.ArraySegmentBinaryGet()
	
	ChangeLaneRail = false
	#Carico prima il punto intermedio
	targetEnd.append(WayPoint)
	if InitialorEndPoints.has(start_key) and InitialorEndPoints.has(end_key):
		global_position = InitialorEndPoints[start_key]
		targetEnd.append(InitialorEndPoints[end_key])
	else:
		printerr("Chiavi partenza/arrivo non valide: ", start_key, end_key)
		return

	current_point_index = 0
	foward = _isFoward(global_position, targetEnd[0])
	
	var first_path = await rail_.getBinary(global_position, targetEnd[0], foward)
	activepath.append(first_path)
	StoryOfPoints.append(first_path)
	
	is_active = true
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if not is_active: return
	if current_point_index <= activepath.size():
		var target_point:Vector2 = activepath[current_point_index]
		var direction: Vector2 = (target_point - global_position).normalized()
		var distance_to_travel : float = delta * speed
		var distance_to_target_point : float = global_position.distance_to(target_point)
		
		await _isNearToCross() 
		
		if ChangeLaneRail :
			activepath[0]= await _isNearToCross()
			StoryOfPoints.append(activepath[0])
			
		if distance_to_travel >= distance_to_target_point:
			activepath[0]=rail_.getBinary(global_position, targetEnd[0], foward)
			StoryOfPoints.append(activepath[0])
			
			global_position = target_point
		if global_position.distance_to(targetEnd[0]) < 3:
			if (targetEnd.size() <= 1) :
				queue_free()
			else:
				targetEnd.remove_at(0)
				foward = _isFoward(global_position,targetEnd[0])
				var next_step = await rail_.getBinary(global_position, targetEnd[0], foward)
				activepath[0] = next_step
			
		else:
			global_position += direction * distance_to_travel
			rotation = direction.angle()

func _isFoward(initialPos: Vector2, endPos : Vector2)->bool:
	if (initialPos.x < endPos.x):
		return true
	else:
		return false

func _isNearToCross() -> Vector2:
	var _vector : Vector2
	var _testVectorPacked : PackedVector2Array
	var trovato_scambio : bool = false
	match foward:
		true:
			for i in range(railSegmentPoints.crossroad.size()):
				var a = global_position.distance_to(railSegmentPoints.crossroad[i].punto0)
				var test = global_position.distance_to(railSegmentPoints.crossroad[10].punto0)
				if a < 8 :
					trovato_scambio = true
					_vector = await  rail_.getCrossRoad(global_position,targetEnd[0],
					activepath[0],railSegmentPoints.crossroad[i].punto0,railSegmentPoints.crossroad[i].punto1)
					break 
				else:
					_vector = activepath[0]
		false:
			for i in range(railSegmentPoints.crossroad.size()):
				var a = global_position.distance_to(railSegmentPoints.crossroad[i].punto1)
				if a < 8 :
					trovato_scambio = true
					_vector = await  rail_.getCrossRoad(global_position,targetEnd[0],
					activepath[0],railSegmentPoints.crossroad[i].punto1,railSegmentPoints.crossroad[i].punto0)
					break 
				else:
					_vector = activepath[0]
	ChangeLaneRail = trovato_scambio
	return _vector
	
	
