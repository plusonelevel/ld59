class_name Planet
extends StaticBody3D

var discovered := false

@export var cam_distance := 1000.0

@onready var mesh := $MeshInstance3D

var satellites: Array[Satellite]

func _ready() -> void:
	mesh.hide()
	for sat in get_tree().get_nodes_in_group("satellite"):
		if sat is Satellite and is_ancestor_of(sat):
			satellites.append(sat)
	

func discover() -> void:
	print_debug("Planet %s discovered!" % [name])
	discovered = true
	Signals.planet_discovered.emit(self)
	mesh.show()


func get_satellites() -> Array[Satellite]:
	return satellites
