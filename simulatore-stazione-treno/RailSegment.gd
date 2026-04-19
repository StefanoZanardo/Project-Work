extends Node2D
class_name RailSegment

var info_rail = BinarioInfo.new()

var mockPackedArray : PackedVector2Array

func get_global_points() -> BinarioInfo:
	info_rail.crossroad.clear()
	info_rail.rail_segment.clear()
	# Scorre tutti i nodi figli di questo RailSegment
	for child in get_children():
		
		# Controlla se il figlio è una Line2D
		if child is Line2D && child.name.to_lower().begins_with('bivio'):
			
			var linea = child
			var xform = linea.get_global_transform()
			

			for p in linea.points:
				info_rail.crossroad.append(xform * p)
				mockPackedArray.append(xform * p)
		elif child is Line2D && child.name.to_lower().begins_with('line'):
			var linea = child
			var xform = linea.get_global_transform()
			
			# Converte i punti di QUESTA linea in globali e li aggiunge al totale
			for p in linea.points:
				info_rail.rail_segment.append(xform * p)
		
				
	
	return info_rail



# Cosa faccio creo due funzioni una che mi ritorna data la nostra posizione quando finisce 
#ritorna il punto del binario così da farla andare avanti 
#Un altra funzione chiamata dal treno quando passa vicino ad un punto crossroad 
#il quale ritorna un Vector2 del camnio corsia
func getBinary(_actualPos: Vector2, targetPoint : Vector2, foward : bool) -> Vector2:
	var _vector : Vector2 
	var binary : BinarioInfo.BinarioInfoTratti = ArraySegmentBinaryGet()
	match foward:
		true:
			for point in binary.rail_segment:
				var point_near_segment = Geometry2D.get_closest_point_to_segment(_actualPos, point.punto0, point.punto1)
				var distance_to_segment = point_near_segment.distance_to(_actualPos)
				if distance_to_segment < 4 :
					_vector = point.punto1
					break
				else:
					#Sarà da gestire gli errori in caso
					print()
		false:
			for point in binary.rail_segment:
				var point_near_segment = Geometry2D.get_closest_point_to_segment(_actualPos, point.punto1, point.punto0)
				var distance_to_segment = point_near_segment.distance_to(_actualPos)
				if distance_to_segment < 4 :
					_vector = point.punto0
					break
				else:
					#Sarà da gestire gli errori in caso
					print()
	return _vector

func getCrossRoad(_actualPos: Vector2, _targetPos : Vector2, _activePath : Vector2 , _crossInit:Vector2 ,_crossTarget:Vector2, _crossBinary:Vector2) -> Vector2:
	var _vector : Vector2
	var pointActivePath = Geometry2D.get_closest_point_to_segment(_targetPos, _crossInit, _activePath)
	var pointTarget = Geometry2D.get_closest_point_to_segment(_targetPos, _crossTarget, _crossBinary) 
	
	if pointTarget.distance_to(_targetPos) < pointActivePath.distance_to(_targetPos):
		return _crossTarget
	else:
		return _activePath
		
	 
	

func ArraySegmentBinaryGet() -> BinarioInfo.BinarioInfoTratti:
	var binary : BinarioInfo = get_global_points()
	var railReturn = BinarioInfo.BinarioInfoTratti.new()
	for i in range(0, binary.rail_segment.size(), 2):
		var inizio = binary.rail_segment[i]
		var fine = binary.rail_segment[i+1]
		railReturn.rail_segment.append(BinarioInfo.PezzoBinario.new(inizio, fine))
	for i in range(0, binary.crossroad.size(), 2):
		var inizio = binary.crossroad[i]
		var fine = binary.crossroad[i+1]
		railReturn.crossroad.append(BinarioInfo.PezzoBinario.new(inizio, fine))
	return railReturn
	

#func calcTargetPointTrain(_actualPos:Vector2,_targetEnd:Vector2)->Vector2:
	#var binary : BinarioInfo = get_global_points()
	#var vector = Vector2(99999,99999)
	#
	#if abs(_actualPos.y - _targetEnd.y) > 20:
		#for cross in binary.crossroad:
			#var dist_y = abs(cross.y - _actualPos.y)
			#if  (35 < dist_y and dist_y < 65) and (vector.x > cross.x) and (_actualPos.x < cross.x):
				#vector = cross
	#elif abs(_actualPos.distance_to(_targetEnd)) <= 10 :
		#vector = Vector2.ZERO
	#else :
		#for _rail in binary.rail_segment:
			#if (abs(_rail.y - _actualPos.y) < 20) and (abs(_rail.x - _actualPos.x)>200):
				#vector = _rail
	#
	#return vector

			
			
	
			
	
