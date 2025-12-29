extends Node2D
class_name RailSegment


func get_global_points() -> BinarioInfo:
	var info_rail = BinarioInfo.new()
	
	# Scorre tutti i nodi figli di questo RailSegment
	for child in get_children():
		
		# Controlla se il figlio è una Line2D
		if child is Line2D && child.name.to_lower().begins_with('bivio'):
			
			var linea = child
			var xform = linea.get_global_transform()
			

			for p in linea.points:
				info_rail.crossroad.append(xform * p)
		elif child is Line2D && child.name.to_lower().begins_with('line'):
			var linea = child
			var xform = linea.get_global_transform()
			
			# Converte i punti di QUESTA linea in globali e li aggiunge al totale
			for p in linea.points:
				info_rail.rail_segment.append(xform * p)
	
	return info_rail
