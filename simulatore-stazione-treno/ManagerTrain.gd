extends Node

@export var train_scene : PackedScene 
@export var rail_system : Node2D        


var InitialorEndPoints : Dictionary = {
	"L1": Vector2(-511.6, 210), "L2": Vector2(-511.6, 260),
	"R1": Vector2(1576.6, 210), "R2": Vector2(1575.6, 260),
	"C2": Vector2(294, 690), "C1": Vector2(227, 708)
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
	stazioni.sort()
	start_menu = find_child("StartPoint", true, false)
	end_menu = find_child("EndPoint", true, false)
	BtnAddQueue = find_child("BtnAddToQueue",true, false)
	BtnLaunchQueue = find_child("BtnLaunchQueue",true,false)
	LabelQueueCount = find_child("LabelCoda", true, false)


	start_menu.clear()
	end_menu.clear()
	

	for s in stazioni:
		start_menu.add_item(s)
		end_menu.add_item(s)
	

	BtnAddQueue.pressed.connect(_on_aggiungi_premuto)
	BtnLaunchQueue.pressed.connect(_on_partenza_premuto)
	
	aggiorna_label()



func _on_aggiungi_premuto():
	var start_idx = start_menu.selected
	var end_idx = end_menu.selected
	
	if start_idx == -1 or end_idx == -1 and start_idx.distance_to(end_idx) > 100:
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
	LabelQueueCount.text = "Treni in coda: " + str(train_queue.size())
