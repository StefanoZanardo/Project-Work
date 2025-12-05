extends PathFollow2D

# Velocità in pixel al secondo
# @export rende la variabile modificabile dall'Inspector di Godot
@export var speed: float = 100.0

func _ready():
	# Disabilita il loop se vuoi che il treno si fermi alla fine
	# Lascialo a true se è un circuito chiuso
	loop = true

func _process(delta):
	# Muove il treno lungo il percorso
	# "progress" è la proprietà nativa di PathFollow2D (equivalente a Progress in C#)
	progress += speed * delta
