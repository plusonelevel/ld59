extends Node

@onready var planet := $World/Planet

var satellites: Array[Node]

var selection: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	satellites = get_tree().get_nodes_in_group("satellite").filter(func(node): return node is Satellite)

	Signals.planet_selected.connect(_on_planet_selected)
	Signals.satellite_selected.connect(_on_satellite_selected)
	Signals.orbit_rotated.connect(_on_orbit_rotated)
	
	satellites[0].activate()
	Signals.planet_selected.emit()


func _on_planet_selected() -> void:
	selection = planet
	Signals.camera_reset.emit()

func _on_satellite_selected(idx: int) -> void:
	var sat := satellites[idx]
	
	if sat and sat is Satellite and sat.activated:
		sat = sat as Satellite
		selection = sat
		Signals.camera_centered.emit(sat)
		
func _on_orbit_rotated(dir: Enums.RotateDirection) -> void:
	if selection and selection is Satellite:
		selection.rotate_orbit(dir)
