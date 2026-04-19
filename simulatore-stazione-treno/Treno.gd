extends Node2D 

@export var speed : float = 200.0
@onready var sprite = $Sprite2D
var rail_ : RailSegment 

var current_point_index : int = 0
var railPoints : BinarioInfo
var activepath : PackedVector2Array
var ChangeLaneRail : bool
var ActualCrossRoad : PackedVector2Array
var foward : bool
var _httpreq : HTTPRequest
var wagons : Array = []
var wagon_spacing : float = 50.0  
var position_history : Array = []
var rotation_history : Array = []
var history_length : int = 500


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

func setup_train(start_key: String, WayPoint:Vector2, end_key: String, rail_system: RailSegment,type_train: String,num_wagons:int = 1):
	rail_ = rail_system 
	railPoints = await rail_.get_global_points()
	railSegmentPoints = await rail_.ArraySegmentBinaryGet()
	
	match type_train:
		"stazionario":
			sprite.texture = load("res://Immagini/Treni/stazionario.png")
			speed = 100
		"regionale":
			sprite.texture = load("res://Assets/Frait train assets blue.png")
			speed = 130
		"veloce":
			sprite.texture = load("res://Assets/RedTrain_.png")
			speed = 180
		"freccia":
			sprite.texture = load("res://Assets/trenoVelocità.png")
			speed = 200
		"transito":
			sprite.texture = load("res://Assets/transizioneTreno.png")
			speed = 80
	
	ChangeLaneRail = false
	#Carico prima il punto intermedio
	targetEnd.append(WayPoint)
	if InitialorEndPoints.has(start_key) and InitialorEndPoints.has(end_key):
		global_position = InitialorEndPoints[start_key]
		targetEnd.append(InitialorEndPoints[end_key])
		
	else:
		return

	current_point_index = 0
	foward = _isFoward(global_position, targetEnd[0])
	for j in range(history_length):
		position_history.append(global_position)
		rotation_history.append(rotation)
	_spawn_wagons(num_wagons)
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
		
		if ChangeLaneRail:
			activepath[0] = await _isNearToCross()
			StoryOfPoints.append(activepath[0])
			
		if distance_to_travel >= distance_to_target_point:
			activepath[0] = rail_.getBinary(global_position, targetEnd[0], foward)
			StoryOfPoints.append(activepath[0])
			global_position = target_point

		if global_position.distance_to(targetEnd[0]) < 3:
			if targetEnd.size() <= 1:
				sprite.visible = false
				is_active = false
				_wait_for_wagons_and_free()
			else:
				targetEnd.remove_at(0)
				foward = _isFoward(global_position, targetEnd[0])
				var next_step = await rail_.getBinary(global_position, targetEnd[0], foward)
				activepath[0] = next_step
		else:
			global_position += direction * distance_to_travel
			rotation = direction.angle()

	# Aggiorna storico
	position_history.push_front(global_position)
	rotation_history.push_front(rotation)
	if position_history.size() > history_length:
		position_history.pop_back()
		rotation_history.pop_back()

	# Aggiorna vagoni — questa riga mancava!
	_update_wagons()

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
				if a < 8 :
					trovato_scambio = true
					var crossBinary = await  rail_.getBinary(railSegmentPoints.crossroad[i].punto1,targetEnd[0],foward)
					
					_vector = await  rail_.getCrossRoad(global_position,targetEnd[0],
					activepath[0],railSegmentPoints.crossroad[i].punto0,railSegmentPoints.crossroad[i].punto1,crossBinary)
					break 
				else:
					_vector = activepath[0]
		false:
			for i in range(railSegmentPoints.crossroad.size()):
				var a = global_position.distance_to(railSegmentPoints.crossroad[i].punto1)
				if a < 8 :
					trovato_scambio = true
					var crossBinary = await  rail_.getBinary(railSegmentPoints.crossroad[i].punto0,targetEnd[0],foward)
					_vector = await  rail_.getCrossRoad(global_position,targetEnd[0],
					activepath[0],railSegmentPoints.crossroad[i].punto1,railSegmentPoints.crossroad[i].punto0,crossBinary)
					break 
				else:
					_vector = activepath[0]
	ChangeLaneRail = trovato_scambio
	return _vector
func _update_wagons() -> void:
	for i in range(wagons.size()):
		# Calcola quanti punti indietro nello storico deve stare questo vagone
		# wagon_spacing è in pixel, quindi convertiamo in "indice storia"
		# Usiamo un passo fisso: più wagon_spacing è grande, più è indietro
		var history_index : int = int(wagon_spacing * (i + 1) * 0.5)
		history_index = clamp(history_index, 0, position_history.size() - 1)
		wagons[i].global_position = position_history[history_index]
		wagons[i].rotation = rotation_history[history_index]

func _spawn_wagons(num_wagons: int) -> void:
	for w in wagons:
		w.queue_free()
	wagons.clear()

	for i in range(num_wagons):
		var wagon = Node2D.new()
		var wagon_sprite = Sprite2D.new()
		wagon_sprite.texture = load("res://Assets/transizioneTreno.png")
		wagon_sprite.scale = sprite.scale
		wagon.add_child(wagon_sprite)
		
		# I vagoni sono figli della SCENA (get_parent()), NON del treno
		# Così si muovono indipendentemente senza essere trascinati
		get_parent().add_child(wagon)
		wagons.append(wagon)
	
func _wait_for_wagons_and_free() -> void:
	# Calcola quanti frame servono perché anche l'ultimo vagone raggiunga la fine
	# L'ultimo vagone è il più indietro nello storico
	var last_index : int = int(wagon_spacing * wagons.size() * 0.5)
	# Converti in secondi: ogni frame a 60fps è ~0.016s
	# last_index = numero di frame di ritardo
	var wait_time : float = last_index / 60.0
	
	await get_tree().create_timer(wait_time).timeout
	
	for w in wagons:
		w.queue_free()
	wagons.clear()
	queue_free()
