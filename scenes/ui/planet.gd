extends Control

@export var sat_scene: PackedScene

func init(planet: Planet) -> void:
	name = planet.name
	$Name/PlanetLabel.text = planet.name
	
	for sat in planet.get_satellites():
		var satellite = sat_scene.instantiate()
		satellite.init(sat)
		$Satellites.add_child(satellite)
		
