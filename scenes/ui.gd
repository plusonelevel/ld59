extends Control

@onready var mainmenu = $MainMenu
@onready var loc = $GameControl/Name/LocName
@onready var ability1_butt = $GameControl/Buttons/ShortRange
@onready var ability2_butt = $GameControl/Buttons/LongRange
@onready var ability3_butt = $GameControl/Buttons/SRhack
@onready var ability4_butt = $GameControl/Buttons/LRhack
@onready var keya = $GameControl/Buttons/KeyA
@onready var keys = $GameControl/Buttons/KeyS
@onready var keyd = $GameControl/Buttons/KeyD
@onready var keyf = $GameControl/Buttons/KeyF
@onready var dialogue_bubble = $GameControl/Dialogue/Panel/RichTextLabel

@export var lines : Array[String]

var line_id = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenu/VBoxContainer/Play.pressed.connect(_on_play_pressed)
	
	Signals.planet_selected.connect(_on_planet_selected)
	Signals.satellite_selected.connect(_on_satellite_selected)
	
	dialogue_bubble.text = lines[line_id]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _unhandled_key_input(event):
	if event.is_action_pressed("select_default"):
		line_id += 1
		if line_id < lines.size():
			dialogue_bubble.text = lines[line_id]
		else:
			dialogue_bubble.text = ""

func _on_play_pressed() -> void:
	mainmenu.hide()
	
func _on_satellite_selected(satellite: Satellite):
	_toggle_abilities(true)
	loc.text = satellite.name

func _on_planet_selected(planet: Node3D):
	_toggle_abilities(false)
	loc.text = planet.name

func _toggle_abilities(enabled: bool):
	if not enabled:
		ability1_butt.disabled = true
		ability2_butt.disabled = true
		ability3_butt.disabled = true
		ability4_butt.disabled = true
		var key_dis_color = Color(0.451, 0.333, 0.431, 1.0)
		keya.modulate = key_dis_color
		keys.modulate = key_dis_color
		keyd.modulate = key_dis_color
		keyf.modulate = key_dis_color
	else:
		ability1_butt.disabled = false
		ability2_butt.disabled = false
		ability3_butt.disabled = false
		ability4_butt.disabled = false
		var key_ab_color = Color(0.671, 0.827, 0.792, 1.0)
		keya.modulate = key_ab_color
		keys.modulate = key_ab_color
		keyd.modulate = key_ab_color
		keyf.modulate = key_ab_color

func _on_ability1_pressed() -> void:
	print_debug("Ability 1 pressed")
	#Signals.ability1.emit()

func _on_ability2_pressed() -> void:
	print_debug("Ability 2 pressed")
	#Signals.ability2.emit()

func _on_ability3_pressed() -> void:
	print_debug("Ability 3 pressed")
	#Signals.ability3.emit()
	
func _on_ability4_pressed() -> void:
	print_debug("Ability 4 pressed")
	Signals.hack.emit()
