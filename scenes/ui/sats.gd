extends Panel

@export var planet_scene: PackedScene

func _ready() -> void:
	Signals.satellite_selected.connect(_on_satellite_selected)
	Signals.planet_discovered.connect(_on_planet_discovered)
	

func _on_satellite_selected(sat: Satellite):
	pass

func _on_planet_discovered(planet: Planet):
	var pl = planet_scene.instantiate()
	pl.init(planet)
	$Planets.add_child(pl)
