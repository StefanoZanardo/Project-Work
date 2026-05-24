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
var IdTrain : String
var IdActualPosition : String
var http_request: HTTPRequest
var datapartenza : String
var number_wagons : int
var end_point : String
var update_timer : Timer


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
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	update_timer = Timer.new()
	add_child(update_timer)
	update_timer.wait_time = 5.0  # 5 secondi
	update_timer.one_shot = false # Ripetilo continuamente
	update_timer.timeout.connect(_on_update_timer_timeout)
	set_physics_process(false)

func setup_train(start_key: String, WayPoint:Vector2, end_key: String, rail_system: RailSegment,type_train: String,num_wagons:int = 1):
	end_point = end_key
	number_wagons = num_wagons
	postTrain(true)
	rail_ = rail_system 
	railPoints = await rail_.get_global_points()
	railSegmentPoints = await rail_.ArraySegmentBinaryGet()

	match type_train:
		"stazionario":
			sprite.texture = load("res://Assets/RedTrain_.png")
			speed = 100 / 2
		"regionale":
			sprite.texture = load("res://Assets/Frait train assets blue.png")
			speed = 130 / 2
		"veloce":
			sprite.texture = load("res://Assets/RedTrain_.png")
			speed = 180 / 2
		"freccia":
			sprite.texture = load("res://Assets/trenoVelocità.png")
			speed = 200 / 2
		"transito":
			sprite.texture = load("res://Assets/transizioneTreno.png")
			speed = 80 / 2
	
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
	update_timer.start()

func _physics_process(delta: float) -> void:
	if not is_active: return
	
	# 1. GESTIONE MOVIMENTO (Solo se il treno NON è ancora arrivato)
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

			# Controllo Arrivo a Destinazione
			if global_position.distance_to(targetEnd[0]) < 3:
				if targetEnd.size() <= 1:
					# --- IL TRENO È ARRIVATO ORA ---
					is_arrived_at_end = true
					update_timer.stop() 
					postTrain(false)         # Fa il PUT IMMEDIATAMENTE e una sola volta!
					sprite.visible = false   # Nasconde la motrice
				else:
					targetEnd.remove_at(0)
					foward = _isFoward(global_position, targetEnd[0])
					var next_step = await rail_.getBinary(global_position, targetEnd[0], foward)
					activepath[0] = next_step
			else:
				global_position += direction * distance_to_travel
				rotation = direction.angle()

		# Aggiorna lo storico delle posizioni
		position_history.push_front(global_position)
		rotation_history.push_front(rotation)
		if position_history.size() > history_length:
			position_history.pop_back()
			rotation_history.pop_back()

	# 2. GESTIONE VAGONI (Fuori dall'IF precedente!)
	# Deve girare sempre, sia mentre il treno cammina, sia quando si ferma per farli sfilare
	_update_wagons()

	# 3. CONTROLLO RIMOZIONE FINALE
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
				wagon_spacing = 55 * 2
			"regionale":
				wagon_sprite.texture = load("res://Assets/Frait train assets blue.png")
				wagon_spacing = 40 * 2
			"veloce":
				wagon_sprite.texture = load("res://Assets/RedTrain_.png")
				wagon_spacing = 45 * 2
			"freccia":
				wagon_sprite.texture = load("res://Assets/trenoVelocità.png")
				wagon_spacing = 40 * 2
			"transito":
				wagon_sprite.texture = load("res://Assets/transizioneTreno.png")
				wagon_spacing = 80 * 2
		wagon_sprite.scale = sprite.scale
		wagon.add_child(wagon_sprite)
			
		
		# I vagoni sono figli della SCENA (get_parent()), NON del treno
		# Così si muovono indipendentemente senza essere trascinati
		get_parent().add_child(wagon)
		wagons.append(wagon)
		
		var starting_history_index : int = int(wagon_spacing * (i + 1) * 0.5)
		wagon.set_meta("h_index", starting_history_index)
	
func _wait_for_wagons_and_free() -> void:
	# 1. Scorriamo la lista dei vagoni al contrario (obbligatorio quando si usa remove_at)
	for i in range(wagons.size() - 1, -1, -1):
		# Se il vagone corrente ha raggiunto il punto finale (distanza < 3 pixel)
		if wagons[i].global_position.distance_to(targetEnd[0]) < 3:
			wagons[i].queue_free() # Rimuovilo dalla scena di gioco
			wagons.remove_at(i)    # Rimuovilo dall'array
			
	# 2. Quando TUTTI i vagoni sono stati eliminati...
	if wagons.size() <= 0:
		wagons.clear()
		set_physics_process(false) # IMPORTANTE: Spegne il loop della fisica per liberare memoria
		queue_free()
		

func postTrain(IsStart: bool):
	var data_odierna_iso = Time.get_datetime_string_from_system(true, false) + ".000Z"
	
	# Variabile per decidere il tipo di richiesta HTTP
	var tipo_richiesta = "PUT"
	
	if IsStart:
		datapartenza = data_odierna_iso
		IdTrain = generate_guid()
		
		tipo_richiesta = "POST" # Se parte adesso, creiamo il treno con POST
	else:
		# Se non è l'inizio, aggiorna la posizione attuale con un nuovo GUID per il PUT
		tipo_richiesta = "PUT"  # Se è già in viaggio, aggiorniamo con PUT

	# Dizionario con le chiavi IDENTICHE a Swagger (fai attenzione a "trainId")
	var dati_da_inviare = {
		"trainId": IdTrain,              # <-- Corretto da "TrainID" a "trainId"
		"destination": end_point,
		"vagons": number_wagons,
		"timeDelay": 0,
		"departureTrain": datapartenza,
		"arrivalTrain": data_odierna_iso, 
		"categoryId": 1
	}
	
	# Invia i dati specificando se POST o PUT
	invia_dati_api(dati_da_inviare, tipo_richiesta,"train")
	
func generate_guid() -> String:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	var b = PackedByteArray()
	for i in range(16):
		b.append(rng.randi() % 256)
	
	b[6] = (b[6] & 0x0F) | 0x40
	b[8] = (b[8] & 0x3F) | 0x80
	
	return "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x" % [
		b[0], b[1], b[2], b[3],
		b[4], b[5],
		b[6], b[7],
		b[8], b[9],
		b[10], b[11], b[12], b[13], b[14], b[15]
	]
func invia_dati_api(dati: Dictionary, typerequest: String, endpointAPI:String):
	var base_url = "http://localhost:5136/%s" % [endpointAPI]
	var url = base_url
	var headers = ["Content-Type: application/json"]
	
	# Convertiamo il dizionario in stringa JSON (di default)
	var json_body = JSON.stringify(dati)
	
	# Variabile che conterrà il metodo HTTP corretto
	var metodo_http = HTTPClient.METHOD_POST
	
	# Usiamo .to_upper() così accetta sia "post" che "POST"
	match typerequest.to_upper():
		"POST":
			metodo_http = HTTPClient.METHOD_POST
			# Il body serve completo, l'url rimane quello base
			
		"PUT":
			metodo_http = HTTPClient.METHOD_PUT
			# Spesso le API vogliono l'ID nell'URL per le modifiche: /train/ID
			if dati.has("TrainID"):
				url = base_url + "/" + str(dati["TrainID"])
				
		"DELETE":
			metodo_http = HTTPClient.METHOD_DELETE
			# Anche per eliminare serve l'ID nell'URL
			if dati.has("TrainID"):
				url = base_url + "/" + str(dati["TrainID"])
			json_body = "" # Le richieste DELETE di solito non hanno un body JSON
			
		"GET":
			metodo_http = HTTPClient.METHOD_GET
			# Se passi un ID cerchi un treno specifico, altrimenti li prendi tutti
			if dati.has("TrainID") and dati["TrainID"] != "":
				url = base_url + "/" + str(dati["TrainID"])
			json_body = "" # Le richieste GET non devono avere un body JSON
			
		_:
			push_error("Errore: Tipo di richiesta '" + typerequest + "' non supportato.")
			return

	# Eseguiamo la richiesta usando le variabili dinamiche impostate dal match
	var error = http_request.request(url, headers, metodo_http, json_body)
	
	if error != OK:
		push_error("Si è verificato un errore durante l'avvio della richiesta HTTP. Codice errore: " + str(error))

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray):
	if response_code >= 200 and response_code < 300:
		print("Successo chiamata", response_code)
	else:
		print("Errore del api")
		print("Codice HTTP: ", response_code)
		if body.size() > 0:
			print("Motivo del rifiuto dal server: ", body.get_string_from_utf8())
		if result != HTTPRequest.RESULT_SUCCESS:
			print("Errore interno di Godot (es. server spento o irraggiungibile). Codice Result: ", result)
			

func _on_update_timer_timeout():
	IdActualPosition = generate_guid()
	var actualPos = {
			  "actualPositionId": IdActualPosition,
			  "x": global_position.x,
			  "y": global_position.y,
			  "speed": speed,
			  "trainId": IdTrain
	}
	invia_dati_api(actualPos,"POST","actualposition")
	
	
	
	
			
	 
