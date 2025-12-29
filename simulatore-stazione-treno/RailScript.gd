extends Node2D
class_name Rail

# Riferimento al prossimo binario (lo colleghi nell'Editor!)
@export var next_rail : Rail 
# Se è uno scambio, potresti avere un array di uscite
@export var possible_next_rails : Array[Rail]

@onready var line_2d: Line2D = $Line2D # Assumi che la Line2D sia figlia

# Funzione per ottenere i punti globali di QUESTO pezzo di binario
func get_path_points() -> PackedVector2Array:
	var local_points = line_2d.points
	var global_points = PackedVector2Array()
	var xform = line_2d.get_global_transform()
	
	for p in local_points:
		global_points.append(xform * p)
		
	return global_points

# Funzione per ottenere il prossimo binario
func get_next_connection() -> Rail:
	if possible_next_rails.size() > 0:
		# LOGICA SCAMBIO: Qui potresti decidere quale ritornare 
		# (es. random, o basato su un segnale)
		return possible_next_rails[0] 
	return next_rail
