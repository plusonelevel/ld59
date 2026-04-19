extends Node

@export var hack_distance := 100.0
@export var hack_angle := 45.0

@export var ping_angle := 30.0

@onready var planet := $World/Planet
@onready var cam := $World/Camera

var satellites: Array[Satellite]

var selection: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	satellites.assign(get_tree().get_nodes_in_group("satellite").filter(func(sat): return sat is Satellite))

	Signals.planet_selected.connect(_on_planet_selected)
	Signals.satellite_selected.connect(_on_satellite_selected)
	Signals.hack.connect(_on_hack_used)
	
	satellites[0].activate()
	Signals.planet_selected.emit()

func _process(_delta: float) -> void:
	if selection is Satellite and Input.is_action_pressed("move_drag"):
		(selection as Satellite).set_target_rotation(cam.get_camera_rotation())
			

func _on_hack_used() -> void:
	if selection is not Satellite:
		return
	var space_state := selection.get_world_3d().direct_space_state
	var origin := selection.global_position
	var possible_targets = []
	for sat in satellites:
		if sat == selection:
			continue
		
		var target := sat.global_position
		var query := PhysicsRayQueryParameters3D.create(origin, origin + (target - origin).normalized() * hack_distance)
		query.exclude = [selection]
		var result := space_state.intersect_ray(query)
		if result.has("collider") and result.collider:
			
			# check if in "line of sight"
			if origin.direction_to(result.collider.position).dot(-selection.global_transform.basis.z) > cos(hack_angle):
				possible_targets.append(result.collider)
		
	print_debug("Objects in range: %d" % [possible_targets.size()])
		

func _on_planet_selected() -> void:
	selection = planet
	Signals.camera_reset.emit()
	Signals.current_location.emit("Planet")

func _on_satellite_selected(idx: int) -> void:
	var sat := satellites[idx]
	
	if sat and sat is Satellite and sat.activated:
		sat = sat as Satellite
		selection = sat
		Signals.camera_centered.emit(sat)
		Signals.current_location.emit("Sat")
		_on_hack_used()
