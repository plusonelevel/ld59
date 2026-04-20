extends Control

@export var sat_scene: PackedScene

func _ready() -> void:
	Signals.planet_beamed.connect(_on_beamed)
	Signals.planet_unlocked.connect(_on_unlocked)

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
		$Satellites.add_child(satellite)
		

func _on_beamed(planet: Planet) -> void:
	if planet.name == name and $Name/SecurityLevel.get_children().size() > 0:
		$Name/SecurityLevel.get_child(0).queue_free()
		
func _on_unlocked(planet: Planet):
	if planet.name == name:
		if name == "???":
			$Name/PlanetLabel.text = "MOTHER"
		
		for i in range(planet.get_satellites().size()):
			var sat = planet.get_satellites()[i]
			$Satellites.get_child(i).init(sat)
