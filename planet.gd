class_name Planet
extends StaticBody3D

var discovered := false

@export var cam_distance := 1000.0


func _ready() -> void:
	pass
	

func discover() -> void:
	print_debug("Planet %s discovered!" % [name])
	discovered = true
	Signals.planet_discovered.emit(self)
