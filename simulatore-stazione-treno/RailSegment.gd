extends Node2D
class_name RailSegment
#Qua ho messo tutti i punti dove i treni potranno partire o arrivare
var InitialorEndPoints : Dictionary = {"L1": Vector2(-511, 210),
	"L2":Vector2(-511,260),"R1":Vector2(1575,210),"R2":Vector2(1575,260),
	"C2":Vector2(294,690),"C1":Vector2(227,708)}
var info_rail = BinarioInfo.new()
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
	
	return info_rail
