extends Control

@onready var mainmenu = $MainMenu
@onready var loc = $GameControl/Name/LocName
@onready var ability1_butt = $GameControl/Buttons/ShortRange
@onready var ability2_butt = $GameControl/Buttons/LongRange
@onready var ability3_butt = $GameControl/Buttons/Unlock

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenu/VBoxContainer/Play.pressed.connect(_on_play_pressed)
	Signals.connect("current_location",_location_change)
	Signals.connect("toggle_abilities",_toggle_abilities)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _location_change(location):
	loc.text = location

func _on_play_pressed() -> void:
	mainmenu.hide()

func _toggle_abilities(input):
	if input == false:
		ability1_butt.disabled = true
		ability2_butt.disabled = true
		ability3_butt.disabled = true
	else:
		ability1_butt.disabled = false
		ability2_butt.disabled = false
		ability3_butt.disabled = false

func _on_ability1_pressed() -> void:
	Signals.ability1.emit()


func _on_ability2_pressed() -> void:
	Signals.ability2.emit()


func _on_ability3_pressed() -> void:
	Signals.ability3.emit()

func _on_unlock_pressed() -> void:
	Signals.hack.emit()
