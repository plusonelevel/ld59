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


func get_satellites() -> Array[Satellite]:
	var result: Array[Satellite] = []
	for sat in get_tree().get_nodes_in_group("satellite"):
		if is_ancestor_of(sat):
			result.append(sat)
	return result
