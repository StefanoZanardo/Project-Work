extends Node2D

@export var current_segment_path : NodePath
var current_segment : Node = null
var t := 0.0
var speed := 200.0
var stopped := false

func _ready():
	if current_segment_path != null:
		current_segment = get_node(current_segment_path)
		# Posiziona il treno sul primo punto del segmento
		position = current_segment.to_global(current_segment.points[0])
		z_index = 1  # sopra la Line2D

		# opzionale: correggi lo spessore della Line2D se necessario
		# position.y -= current_segment.$Line2D.width / 2

func _physics_process(delta):
	if current_segment == null or stopped:
		return

	# posizione globale dei punti
	var start_pos = current_segment.to_global(current_segment.points[0])
	var end_pos = current_segment.to_global(current_segment.points[1])

	t += speed * delta / current_segment.length()
	if t >= 1.0:
		t = 1.0
		stopped = true  # ferma il treno

	position = start_pos.lerp(end_pos, t)
	rotation = (end_pos - start_pos).angle()
