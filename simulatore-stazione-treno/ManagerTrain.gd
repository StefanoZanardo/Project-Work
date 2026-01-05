extends Node

@export var train_scene : PackedScene 
@export var rail_system : Node2D        


var InitialorEndPoints : Dictionary = {
	"L1": Vector2(-511.6, 210), "L2": Vector2(-511.6, 260),
	"R1": Vector2(1576.6, 210), "R2": Vector2(1575.6, 260),
	"C1": Vector2(227, 708),"C2": Vector2(294, 690)
}

var train_queue : Array = []
var is_spawning : bool = false 
var start_menu : OptionButton
var end_menu : OptionButton
var BtnAddQueue : Button
var BtnLaunchQueue : Button
var LabelQueueCount : Label

func _ready():
	var stazioni = InitialorEndPoints.keys()
	start_menu = find_child("StartPoint", true, false)
	end_menu = find_child("EndPoint", true, false)
	BtnAddQueue = find_child("BtnAddToQueue",true, false)
	BtnLaunchQueue = find_child("BtnLaunchQueue",true,false)
	LabelQueueCount = find_child("LabelCoda", true, false)

	start_menu.item_selected.connect(_on_start_selected)
	end_menu.item_selected.connect(_on_end_selected)

	BtnAddQueue.pressed.connect(_on_aggiungi_premuto)
	BtnLaunchQueue.pressed.connect(_on_partenza_premuto)
	
	aggiorna_label()
	if start_menu.item_count > 0:
		start_menu.select(0)
		_on_start_selected(0)

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
	var end_idx = end_menu.selected
	
	if start_idx == -1 or end_idx == -1:
		return 

	var start_val = start_menu.get_item_text(start_idx)
	var end_val = end_menu.get_item_text(end_idx)
	

	
	train_queue.append({"start": start_val, "end": end_val})
	aggiorna_label()

func _on_partenza_premuto():
	if is_spawning or train_queue.is_empty():
		return
		
	is_spawning = true
	BtnLaunchQueue.disabled = true 

	while train_queue.size() > 0:
		var dati_treno = train_queue.pop_front()
		aggiorna_label()
		
		spawn_train(dati_treno["start"], dati_treno["end"])
		
		#Qua è la pausa fra treni bisognerà migliorarla
		await get_tree().create_timer(2.0).timeout
		
	is_spawning = false
	BtnLaunchQueue.disabled = false


func spawn_train(start_key: String, end_key: String):
		
	var new_train = train_scene.instantiate()
	add_child(new_train)
	

	new_train.setup_train(start_key, end_key, rail_system)


func aggiorna_label():
	
	var stazioni = InitialorEndPoints.keys()
	start_menu.clear()
	end_menu.clear()
	
	for s in stazioni:
		start_menu.add_item(s)
		end_menu.add_item(s)
	LabelQueueCount.text = "Treni in coda: " + str(train_queue.size())
