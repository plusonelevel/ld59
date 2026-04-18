extends Node

@onready var planet := $World/Planet
var satellites: Array[Node]

var selection: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	satellites = get_tree().get_nodes_in_group("satellite")

	Signals.select_planet.connect(_on_planet_selected)
	Signals.select_satellite.connect(_on_satellite_selected)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_planet_selected() -> void:
	selection = planet
	Signals.camera_reset.emit()

func _on_satellite_selected(idx: int) -> void:
	var sat := satellites[idx]
	
	if sat and sat is Satellite:
		sat = sat as Satellite
		selection = sat
		Signals.camera_centered.emit(sat.get_satellite())
