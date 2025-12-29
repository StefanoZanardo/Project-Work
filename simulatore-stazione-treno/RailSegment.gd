extends Node2D
class_name RailSegment

func get_global_points() -> PackedVector2Array:
	var total_points = PackedVector2Array()
	
	# Scorre tutti i nodi figli di questo RailSegment
	for child in get_children():
		
		# Controlla se il figlio è una Line2D
		if child is Line2D:
			var linea = child
			var xform = linea.get_global_transform()
			
			# Converte i punti di QUESTA linea in globali e li aggiunge al totale
			for p in linea.points:
				total_points.append(xform * p)
	
	return total_points
