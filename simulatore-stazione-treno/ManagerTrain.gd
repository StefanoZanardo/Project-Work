extends Node

@export var train_scene : PackedScene 
@export var rail_system : Node2D   
@export var rail_middle : StationPoints


var InitialorEndPoints : Dictionary = {
	"L1": Vector2(-511.6, 210), "L2": Vector2(-511.6, 260),
	"R1": Vector2(1576.6, 210), "R2": Vector2(1575.6, 260),
	#"C1": Vector2(227, 708),"C2": Vector2(294, 690)
}
#Punti intermedi 
var MiddlePoints : Dictionary  
var numwagons : int = 0

var http_request: HTTPRequest
var train_queue : Array = []
var is_spawning : bool = false 
var start_menu : OptionButton
var middle_menu : OptionButton
var end_menu : OptionButton
var BtnAddQueue : Button
var BtnLaunchQueue : Button
var LabelQueueCount : Label
var type_menu : OptionButton
var LabelNunWagons : Label
var BtnAddWagons : Button
var BtnRemoveWagons : Button

func _ready():
	MiddlePoints = rail_middle.getintermediatePoint()
	#Assegnare tutti gli elementi grafici a una variabile
	var stazioni = InitialorEndPoints.keys()
	start_menu = find_child("StartPoint", true, false)
	middle_menu = find_child("MiddlePoint", true, false)
	end_menu = find_child("EndPoint", true, false)
	BtnAddQueue = find_child("BtnAddToQueue",true, false)
	BtnLaunchQueue = find_child("BtnLaunchQueue",true,false)
	LabelQueueCount = find_child("LabelCoda", true, false)
	type_menu = find_child("TypeTrain", true, false)
	LabelNunWagons = find_child("LabelNumWag", true, false)
	BtnAddWagons = find_child("ButtonAdd", true, false)
	BtnRemoveWagons = find_child("ButtonRemove", true , false)
	
	

	start_menu.item_selected.connect(_on_start_selected)
	end_menu.item_selected.connect(_on_end_selected)
	
	#http_request = HTTPRequest.new()
	#add_child(http_request)
	#http_request.request_completed.connect(_on_request_completed)

	BtnAddQueue.pressed.connect(_on_aggiungi_premuto)
	BtnLaunchQueue.pressed.connect(_on_partenza_premuto)
	
	BtnAddWagons.pressed.connect(wagonbtn.bind(true))
	BtnRemoveWagons.pressed.connect(wagonbtn.bind(false))
	
	aggiorna_label()
	type_menu.clear()
	var tipi_treno = ["stazionario", "regionale", "veloce", "freccia", "transito"]
	for tipo in tipi_treno:
		type_menu.add_item(tipo)
	for pmid in MiddlePoints:
		middle_menu.add_item(pmid)
	middle_menu.select(0)
	if start_menu.item_count > 0:
		start_menu.select(0)
		_on_start_selected(0)

func wagonbtn(isAdd:bool):
	if(isAdd):
		if(numwagons < 10):
			numwagons = numwagons + 1
		else:
			return
	else:
		if(numwagons > 0):
			numwagons = numwagons - 1
		else:
			return;
	LabelNunWagons.text = "N° Wagons: %s" % numwagons
	

func _on_start_selected(index: int) -> void:
	var pos = start_menu.get_item_text(index)
	var vectorselected = InitialorEndPoints[pos]
	aggiorna_menu(end_menu, vectorselected,pos)


func _on_end_selected(index: int) -> void:
	var pos = end_menu.get_item_text(index)
	var vectorselected = InitialorEndPoints[pos]
	aggiorna_menu(start_menu, vectorselected,pos)


func aggiorna_menu(menu: OptionButton, valore_scelto: Vector2, nameindex:String) -> void:
	
	for i in range(menu.item_count):
		var key = menu.get_item_text(i)
		var pos: Vector2 = InitialorEndPoints[key]
		var disable = abs(valore_scelto.x - pos.x) < 200 or disablePoints(key,nameindex) 
		menu.set_item_disabled(i, disable)

func disablePoints(listpoint:String, pointselected : String) -> bool:
	if pointselected.begins_with('C') :
		if listpoint.begins_with('R'):
			return true
	if pointselected.begins_with('R'):
		if listpoint.begins_with('C'):
			return true
	return false
			
		 
	

func _on_aggiungi_premuto():
	
	
	var start_idx = start_menu.selected
	var middle_idx = middle_menu.selected
	var end_idx = end_menu.selected
	
	
	var tipo_treno_selezionato = type_menu.get_item_text(type_menu.selected)
	var name_middle = middle_menu.get_item_text(middle_idx)
	
	if start_idx == -1 or end_idx == -1:
		return 

	var start_val = start_menu.get_item_text(start_idx)
	var middle_val = MiddlePoints.get(name_middle)
	var end_val = end_menu.get_item_text(end_idx)
	

	
	train_queue.append({"start": start_val, "middle": middle_val , "end": end_val, "type": tipo_treno_selezionato,"number_wagon": numwagons})
	aggiorna_label()

func _on_partenza_premuto():
	if is_spawning or train_queue.is_empty():
		return
		
	is_spawning = true
	BtnLaunchQueue.disabled = true 

	while train_queue.size() > 0:
		var dati_treno = train_queue.pop_front()
		aggiorna_label()
		
		spawn_train(dati_treno["start"], dati_treno["middle"], dati_treno["end"], dati_treno["type"], dati_treno["number_wagon"])
		
		#Qua è la pausa fra treni bisognerà migliorarla
		await get_tree().create_timer(2.0).timeout
		
	is_spawning = false
	BtnLaunchQueue.disabled = false


func spawn_train(start_key: String,middle_key : Vector2, end_key: String, type_tr: String, number_wagon:int):
		
	var new_train = train_scene.instantiate()
	add_child(new_train)
	

	new_train.setup_train(start_key,middle_key, end_key, rail_system,type_tr,number_wagon)
	# Mettendo false al secondo parametro, Godot userà la 'T' invece dello spazio
	
	


func aggiorna_label():
	
	var stazioni = InitialorEndPoints.keys()
	start_menu.clear()
	end_menu.clear()
	
	
	for s in stazioni:
		start_menu.add_item(s)
		end_menu.add_item(s)
	start_menu.select(0)
	LabelQueueCount.text = "Treni in coda: " + str(train_queue.size())
