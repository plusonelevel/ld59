class_name Planet
extends StaticBody3D

var discovered := false

@export var cam_distance := 1000.0
@onready var mesh := $MeshInstance3D

func _ready() -> void:
	mesh.hide()
	

func discover() -> void:
	print_debug("Planet %s discovered!" % [name])
	discovered = true
	Signals.planet_discovered.emit(self)
	mesh.show()


func get_satellites() -> Array[Satellite]:
	var result: Array[Satellite] = []
	for sat in get_tree().get_nodes_in_group("satellite"):
		if is_ancestor_of(sat):
			result.append(sat)
	return result
