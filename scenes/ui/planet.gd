extends Control

@export var sat_scene: PackedScene

func _ready() -> void:
	Signals.planet_beamed.connect(_on_beamed)

func init(planet: Planet) -> void:
	name = planet.name
	$Name/PlanetLabel.text = planet.name
	
	for x in range(0, planet.security_level):
		var hitpoint = Label.new()
		hitpoint.name = "%d" % [x]
		hitpoint.text = "I"
		$Name/SecurityLevel.add_child(hitpoint)
	
	for sat in planet.get_satellites():
		var satellite = sat_scene.instantiate()
		satellite.init(sat)
		$Satellites.add_child(satellite)
		

func _on_beamed(planet: Planet) -> void:
	if planet.name == name and $Name/SecurityLevel.get_children().size() > 0:
		$Name/SecurityLevel.get_child(0).queue_free()
