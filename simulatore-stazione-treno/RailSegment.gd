extends Node2D
class_name RailSegment

var info_rail = BinarioInfo.new()
var mockPackedArray : PackedVector2Array
func get_global_points() -> BinarioInfo:
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
				mockPackedArray.append(xform * p)
	print(mockPackedArray)
	return info_rail

func calcTargetPointTrain(_actualPos:Vector2,_targetEnd:Vector2)->Vector2:
	var binary : BinarioInfo = get_global_points()
	var vector = Vector2(99999,99999)
	
	if abs(_actualPos.y - _targetEnd.y) > 20:
		for cross in binary.crossroad:
			var dist_y = abs(cross.y - _actualPos.y)
			if  (35 < dist_y and dist_y < 65) and (vector.x > cross.x) and (_actualPos.x < cross.x):
				vector = cross
	elif abs(_actualPos.distance_to(_targetEnd)) <= 10 :
		vector = Vector2.ZERO
	else :
		for _rail in binary.rail_segment:
			if (abs(_rail.y - _actualPos.y) < 20) and (abs(_rail.x - _actualPos.x)>200):
				vector = _rail
	
	return vector
# Cosa faccio creo due funzioni una che mi ritorna data la nostra posizione quando finisce 
#ritorna il punto del binario così da farla andare avanti 
#Un altra funzione chiamata dal treno quando passa vicino ad un punto crossroad 
#il quale ritorna un Vector2 del camnio corsia
func getBinary(_actualPos: Vector2, foward : bool) -> Vector2:
	var _vector : Vector2 
	var binary : BinarioInfo = get_global_points()
	match foward:
		true:
			for point in binary.rail_segment:
				if (_actualPos.x + point.x) > 100 and abs(_actualPos.y - point.y) < 20:
					_vector = point
		false:
			for point in binary.rail_segment:
				if (_actualPos.x - point.x) < 100 and abs(_actualPos.y - point.y) < 20:
					_vector = point
	return _vector

			
			
	
			
	
