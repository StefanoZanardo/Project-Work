extends RefCounted
class_name BinarioInfo 
var rail_segment : PackedVector2Array = PackedVector2Array()
var crossroad : PackedVector2Array = PackedVector2Array()

class PezzoBinario:
	var punto0 : Vector2 = Vector2.ZERO
	var punto1 : Vector2 = Vector2.ZERO
	func _init(_punto0 : Vector2, _punto1: Vector2) -> void:
		punto0 = _punto0
		punto1 = _punto1
		

class BinarioInfoTratti:
	var rail_segment : Array[PezzoBinario] = []
	var crossroad : Array[PezzoBinario] = []
