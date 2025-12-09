extends Node2D

var points : Array = []

func _ready():
	points = $Line2D.points
	print("Punti RailSegment:", points)

func length() -> float:
	return points[0].distance_to(points[1])
