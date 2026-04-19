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
var is_arrived_at_end : bool = false


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
			sprite.texture = load("res://Assets/RedTrain_.png")
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
	_spawn_wagons(num_wagons,type_train)
	var first_path = await rail_.getBinary(global_position, targetEnd[0], foward)
	activepath.append(first_path)
	StoryOfPoints.append(first_path)
	
	is_active = true
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if not is_active: return
	if not is_arrived_at_end:
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
	if is_arrived_at_end:
		_wait_for_wagons_and_free()

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
		var w = wagons[i]
		# Leggi l'indice che abbiamo salvato nel vagone
		var current_h_index = w.get_meta("h_index")
		
		# Se il treno è fermo, facciamo scorrere il vagone in avanti nello storico
		if is_arrived_at_end:
			current_h_index -= 1 # Muove il vagone verso il traguardo
			current_h_index = max(0, current_h_index) # Non andare sotto lo zero
			w.set_meta("h_index", current_h_index) # Salva la nuova posizione
			
		var safe_index = clamp(current_h_index, 0, position_history.size() - 1)
		w.global_position = position_history[safe_index]
		w.rotation = rotation_history[safe_index]

func _spawn_wagons(num_wagons: int, type_train:String) -> void:
	for w in wagons:
		w.queue_free()
	wagons.clear()

	for i in range(num_wagons):
		var wagon = Node2D.new()
		var wagon_sprite = Sprite2D.new()
		match type_train:
			"stazionario":
				wagon_sprite.texture = load("res://Assets/Wagons/VagoneMerci.png")
				wagon_spacing = 45
			"regionale":
				wagon_sprite.texture = load("res://Assets/Frait train assets blue.png")
				wagon_spacing = 40
			"veloce":
				wagon_sprite.texture = load("res://Assets/RedTrain_.png")
				wagon_spacing = 45
			"freccia":
				wagon_sprite.texture = load("res://Assets/trenoVelocità.png")
				wagon_spacing = 40
			"transito":
				wagon_sprite.texture = load("res://Assets/transizioneTreno.png")
				wagon_spacing = 80
		wagon_sprite.scale = sprite.scale
		wagon.add_child(wagon_sprite)
			
		
		# I vagoni sono figli della SCENA (get_parent()), NON del treno
		# Così si muovono indipendentemente senza essere trascinati
		get_parent().add_child(wagon)
		wagons.append(wagon)
		
		var starting_history_index : int = int(wagon_spacing * (i + 1) * 0.5)
		wagon.set_meta("h_index", starting_history_index)
	
func _wait_for_wagons_and_free() -> void:
	# Calcola quanti frame servono perché anche l'ultimo vagone raggiunga la fine
	# L'ultimo vagone è il più indietro nello storico
	
	#var last_index : int = int(wagon_spacing * wagons.size() * 0.5)
	## Converti in secondi: ogni frame a 60fps è ~0.016s
	## last_index = numero di frame di ritardo
	#var wait_time : float = last_index / 60.0
	#
	#await get_tree().create_timer(wait_time).timeout
	

	for i in range(wagons.size() - 1, -1, -1):
		if wagons[i].global_position.distance_to(targetEnd[0]) < 3:
			wagons[i].queue_free()
			wagons.remove_at(i)
			
	
	if(wagons.size() <= 0):
		
		wagons.clear()
	
	
	
	
			
	 
