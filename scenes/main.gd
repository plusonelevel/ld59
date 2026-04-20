extends Node

@export var hack_distance := 100.0
@export var hack_angle := 45.0

@export var ping_distance := 1000.0

@export var scan_distance := 100000.0
@export var scan_angle := 60.0

@onready var cam := $World/Camera

var satellites: Array[Satellite]
var discovered_planets: Array[Planet]
var undiscovered_planets: Array[Planet]

var selection: Variant
var planet: Variant


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	satellites.assign(get_tree().get_nodes_in_group("satellite").filter(
		func(sat): return sat is Satellite
	))
	discovered_planets = []
	undiscovered_planets.assign(get_tree().get_nodes_in_group("planet").filter(
		func(p): return p is Planet and not p.discovered
	))

	Signals.planet_discovered.connect(_on_planet_discovered)
	Signals.planet_selected.connect(_on_planet_selected)
	Signals.satellite_selected.connect(_on_satellite_selected)
	Signals.hack.connect(_on_hack_used)
	Signals.beam.connect(_on_beam_used)
	Signals.ping.connect(_on_ping_used)
	Signals.scan.connect(_on_scan_used)
	
	
	var starting_sat = satellites[0]
	starting_sat.activate()
	Signals.satellite_selected.emit(starting_sat)

func _process(_delta: float) -> void:
	if InputListener.dialogue_active:
		return
	if selection is Satellite and Input.is_action_pressed("move_drag"):
		(selection as Satellite).set_target_rotation(cam.get_camera_rotation())
			
func _input(event: InputEvent) -> void:
	if selection is Satellite:	
		if event.is_action_pressed("move_drag"):
			selection.aim_start()
		elif event.is_action_released("move_drag"):
			selection.aim_stop()
	

func _unhandled_key_input(event: InputEvent) -> void:
	if InputListener.dialogue_active:
		return
	if event.is_action_pressed("select_1"):
		_select_satellite(0)
	elif event.is_action_pressed("select_2"):
		_select_satellite(1)
	elif event.is_action_pressed("select_3"):
		_select_satellite(2)
	elif event.is_action_pressed("unselect") and planet:
		if selection:
			selection = null
			Signals.planet_selected.emit(planet)
		else:
			var current_idx = discovered_planets.find(planet)
			var next_planet = discovered_planets[(current_idx + 1) % discovered_planets.size()]
			Signals.planet_selected.emit(next_planet)

func _select_satellite(idx: int):
	var sat = satellites[idx]
	if sat and sat.activated:
		Signals.satellite_selected.emit(sat)


func _on_hack_used() -> void:
	if InputListener.dialogue_active:
		return
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
			print_debug("angle to %s: %f" % [result.collider.name, accuracy])
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

func _on_ping_used():
	if selection is not Satellite:
		return
		
	var sel = selection as Satellite
	sel.ping()
	var space_state := sel.get_world_3d().direct_space_state
	var origin: Vector3 = sel.global_position
	
	for p in undiscovered_planets:
		var pl := p as Planet
		var target := pl.global_position
		var query := PhysicsRayQueryParameters3D.create(origin, origin + (target - origin).normalized() * ping_distance)
		query.collision_mask = 0b00000010
		var result := space_state.intersect_ray(query)
		DebugDraw.draw_line(query.from, query.to, Color.WEB_PURPLE, 5.0)
		if result.has("collider") and result.collider and result.collider == pl:
			pl.discover()
			if not planet:
				planet = pl

func _on_beam_used():
	if selection is Satellite:
		selection.beam_fail()
		(find_child("Planet2") as Planet).discover()

func _on_scan_used():
	if selection is not Satellite:
		return
	var sel = selection as Satellite
	sel.scan()
	var space_state := sel.get_world_3d().direct_space_state
	var origin: Vector3 = sel.global_position
	var possible_targets: Array[Planet] = []
	
	for p in undiscovered_planets:
		var target := p.global_position
		var query := PhysicsRayQueryParameters3D.create(origin, origin + (target - origin).normalized() * scan_distance)
		query.collision_mask = 0b00000010
		var result := space_state.intersect_ray(query)
		DebugDraw.draw_line(query.from, query.to, Color.ORANGE, 5.0)
		if result.has("collider") and result.collider and result.collider == p:
			
			# check if in "line of sight"
			#DebugDraw.draw_arrow_ray(origin, origin.direction_to(result.collider.global_position) * 100, 20.0, 10.0, Color.ALICE_BLUE, 5.0)
			#DebugDraw.draw_arrow_ray(origin, -selection.global_transform.basis.z * 100, 20, 10, Color.BISQUE, 5.0)
			var accuracy := origin.direction_to(result.collider.global_position).dot(-sel.global_transform.basis.z)
			print_debug("angle to %s: %f" % [result.collider.name, accuracy])
			if accuracy > cos(scan_angle):
				possible_targets.append(result.collider)
			else:
				print_debug("Planet %s out of sight" % [result.collider.name])
		else:
			print_debug("Object out of range or not a planet")
	
	for p in possible_targets:
		p.discover()


func _on_planet_discovered(new_planet: Planet) -> void:
	discovered_planets.append(new_planet)
	undiscovered_planets.erase(new_planet)


func _on_planet_selected(new_planet: Planet) -> void:
	if new_planet.discovered:
		planet = new_planet
		selection = null

func _on_satellite_selected(sat: Satellite) -> void:
	if sat.activated:
		selection = sat
