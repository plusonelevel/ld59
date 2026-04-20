extends Control

func _ready() -> void:
	Signals.satellite_activated.connect(_on_satellite_activated)

func init(sat: Satellite):
	name = sat.name
	$Unlocked/Label.text = sat.name
	
	$Locked.hide()
	$Unlocked.show()
	if sat.activated:
		_activate()
	else:
		$Unlocked/Online.hide()
		$Unlocked/Offline.show()

func _activate():
	$Unlocked/Online.show()
	$Unlocked/Offline.hide()

func _on_satellite_activated(sat: Satellite):
	if sat.name == name:
		_activate()
