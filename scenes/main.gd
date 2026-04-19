extends Node

@export var hack_distance := 100.0
@export var hack_angle := 45.0

@export var ping_angle := 30.0

@onready var planet := $World/Aiga
@onready var cam := $World/Camera

var satellites: Array[Satellite]

var selection: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	satellites.assign(get_tree().get_nodes_in_group("satellite").filter(
		func(sat): return sat is Satellite
	))

	Signals.planet_selected.connect(_on_planet_selected)
	Signals.satellite_selected.connect(_on_satellite_selected)
	Signals.hack.connect(_on_hack_used)
	
	satellites[0].activate()
	Signals.planet_selected.emit(planet)

func _process(_delta: float) -> void:
	if selection is Satellite and Input.is_action_pressed("move_drag"):
		(selection as Satellite).set_target_rotation(cam.get_camera_rotation())
			

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("select_1"):
		_select_satellite(0)
	elif event.is_action_pressed("select_2"):
		_select_satellite(1)
	elif event.is_action_pressed("select_3"):
		_select_satellite(2)
	elif event.is_action_pressed("select_default"):
		Signals.planet_selected.emit(planet)

func _select_satellite(idx: int):
	var sat = satellites[idx]
	if sat and sat.activated:
		Signals.satellite_selected.emit(sat)

func _on_hack_used() -> void:
	if selection is not Satellite:
		return
	var sel = selection as Satellite
	var space_state := sel.get_world_3d().direct_space_state
	var origin: Vector3 = sel.global_position
	var possible_targets = []
	for sat in satellites:
		if sat == sel:
			continue
		
		var target := sat.global_position
		var query := PhysicsRayQueryParameters3D.create(origin, origin + (target - origin).normalized() * hack_distance)
		query.exclude = [sel]
		var result := space_state.intersect_ray(query)
		DebugDraw.draw_line(query.from, query.to, Color.GREEN_YELLOW, 5.0)
		if result.has("collider") and result.collider and result.collider is Satellite:
			
			# check if in "line of sight"
			#DebugDraw.draw_arrow_ray(origin, origin.direction_to(result.collider.global_position) * 100, 20.0, 10.0, Color.ALICE_BLUE, 5.0)
			#DebugDraw.draw_arrow_ray(origin, -selection.global_transform.basis.z * 100, 20, 10, Color.BISQUE, 5.0)
			var accuracy := origin.direction_to(result.collider.global_position).dot(-sel.global_transform.basis.z)
			if accuracy > cos(hack_angle):
				possible_targets.append([result.collider, accuracy])
			else:
				print_debug("Object %s out of sight" % [result.collider.name])
		else:
			print_debug("Object out of range or not a satellite")
		
	print_debug("Objects in range: %s" % [possible_targets])
	if possible_targets.size() > 0:
		possible_targets.sort_custom(func(a, b): a[1] > b[1])
		var target = possible_targets[0][0] as Satellite
		if target:
			sel.hack(target)
			await get_tree().create_timer(3.0).timeout
			target.activate()
	else:
		sel.hack_fail()

func _on_planet_selected(new_planet: Node3D) -> void:
	planet = new_planet
	selection = planet

func _on_satellite_selected(sat: Satellite) -> void:
	if sat.activated:
		selection = sat
