extends Control

@onready var mainmenu = $MainMenu
@onready var anim = $MainMenu/AnimationPlayer
@onready var loc = $GameControl/Name/LocName
@onready var satboard = $GameControl/Sats
@onready var name_tag = $GameControl/Name
@onready var abilities_bar = $GameControl/Buttons
@onready var time_scale := $GameControl/TimeScale
@onready var time_scale_value := $GameControl/TimeScale/Value
@onready var ability1_butt = $GameControl/Buttons/ShortRange
@onready var ability2_butt = $GameControl/Buttons/LongRange
@onready var ability3_butt = $GameControl/Buttons/SRhack
@onready var ability4_butt = $GameControl/Buttons/LRhack
@onready var ability5_butt = $GameControl/Buttons/Soothe
@onready var keya = $GameControl/Buttons/ShortRange/KeyA
@onready var keys = $GameControl/Buttons/LongRange/KeyS
@onready var keyd = $GameControl/Buttons/SRhack/KeyD
@onready var keyf = $GameControl/Buttons/LRhack/KeyF
@onready var dialogue_overlay = $GameControl/Dialogue
@onready var dialogue_bubble = $GameControl/Dialogue/Panel/RichTextLabel
@onready var next_line = $GameControl/Dialogue/Panel/Next
@onready var skip_button = $MainMenu/Skip
@onready var countdown = $GameControl/Sats/Countdown
@onready var countdown_timer = $CountdownTimer
@onready var credits = $MainMenu/Credits
@onready var quit_butt = $MainMenu/VBoxContainer/Quit

@export var lines: Array[String]

var line_id := 0
var dialogue_active := false
var start_game_controls := false

var selected_satellite: Variant

func _ready() -> void:
	Signals.planet_selected.connect(_on_planet_selected)
	Signals.satellite_selected.connect(_on_satellite_selected)
	Signals.time_scale_set.connect(_on_time_scale_set)
	
	Signals.mother_soothed.connect(func(): countdown_timer.paused = true)
	
	_on_time_scale_set(1.0)

	anim.animation_finished.connect(_on_animation_finished)

	dialogue_active = false
	start_game_controls = false
	next_line.hide()
	line_id = 0
	
	#Startup show/hide UI logic
	mainmenu.show()
	satboard.hide()
	name_tag.hide()
	abilities_bar.hide()
	dialogue_overlay.show()
	
	if OS.has_feature("web"):
		quit_butt.hide()
	
	_toggle_abilities(false)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("dialog_progress"):
		if anim.is_playing() and anim.current_animation == "start_game":
			skip_animation()
			get_viewport().set_input_as_handled()

func skip_animation():
	if not skip_button.visible:
		skip_button.show()
		get_tree().create_timer(2.0).timeout.connect(func(): skip_button.hide())
	else:
		anim.seek(20, true)
		skip_button.hide()
		start_dialogue()


func _unhandled_input(event: InputEvent) -> void:
	if not dialogue_active:
		return

	if not start_game_controls:
		get_viewport().set_input_as_handled()
		return

	var next_pressed := false

	if event.is_action_pressed("dialog_progress"):
		next_pressed = true
	elif event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			next_pressed = true

	if next_pressed:
		next_dialogue_line()
		get_viewport().set_input_as_handled()
		return

	get_viewport().set_input_as_handled()

func next_dialogue_line() -> void:
	line_id += 1

	if line_id < lines.size():
		dialogue_bubble.text = lines[line_id]
	else:
		end_dialogue()
	if line_id == 5:
		satboard.show()
		name_tag.show()
		
	if line_id == 10:
		_start_countdown()
	

func start_dialogue() -> void:
	mainmenu.hide()
	dialogue_active = true
	InputListener.input_locked = false
	InputListener.dialogue_active = true
	InputListener.dialogue_ui = self
	next_line.show()
	_toggle_abilities(false)

	line_id = 0
	if lines.size() > 0:
		dialogue_bubble.text = lines[line_id]

func end_dialogue() -> void:
	dialogue_active = false
	InputListener.input_locked = false
	InputListener.dialogue_active = false
	InputListener.dialogue_ui = null
	next_line.hide()
	dialogue_overlay.hide()
	_toggle_abilities(true)

func _on_play_pressed() -> void:
	credits.hide()
	start_game_controls = false
	InputListener.input_locked = true
	anim.play("start_game")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "start_game":
		start_game_controls = true
		start_dialogue()
	skip_button.hide()

func _on_satellite_selected(satellite: Satellite) -> void:
	selected_satellite = satellite
	if dialogue_active:
		return
		
	if satellite.name == "Soother":
		_toggle_soother(true)
	else:
		_toggle_soother(false)
		_toggle_abilities(true)
	
	loc.text = satellite.name

func _on_planet_selected(planet: Planet):
	if dialogue_active:
		return
	_toggle_abilities(false)
	loc.text = planet.name

func _toggle_abilities(enabled: bool) -> void:
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
		abilities_bar.show()
		ability1_butt.disabled = !selected_satellite.can_ping
		ability2_butt.disabled = !selected_satellite.can_scan
		ability3_butt.disabled = !selected_satellite.can_hack
		ability4_butt.disabled = !selected_satellite.can_beam
		ability1_butt.show()
		ability2_butt.show()
		ability3_butt.show()
		ability4_butt.show()

		var key_ab_color = Color(0.671, 0.827, 0.792, 1.0)
		keya.modulate = key_ab_color
		keys.modulate = key_ab_color
		keyd.modulate = key_ab_color
		keyf.modulate = key_ab_color

func _toggle_soother(is_soother: bool):
	ability1_butt.visible = !is_soother
	ability2_butt.visible = !is_soother
	ability3_butt.visible = !is_soother
	ability4_butt.visible = !is_soother
	ability5_butt.visible = is_soother
	ability5_butt.disabled = !is_soother 

func _on_ability1_pressed() -> void:
	if dialogue_active or not selected_satellite.can_ping:
		return
	print_debug("Ability 1 pressed")
	Signals.ping.emit()

func _on_ability2_pressed() -> void:
	if dialogue_active or not selected_satellite.can_scan:
		return
	print_debug("Ability 2 pressed")
	Signals.scan.emit()

func _on_ability3_pressed() -> void:
	if dialogue_active or not selected_satellite.can_hack:
		return
	print_debug("Ability 3 pressed")
	Signals.hack.emit()
	
func _on_ability4_pressed() -> void:
	if dialogue_active or not selected_satellite.can_beam:
		return
	print_debug("Ability 4 pressed")
	Signals.beam.emit()

func _on_ability5_pressed() -> void:
	if dialogue_active or selected_satellite.name != "Soother":
		return
	print_debug("Ability 5 pressed")
	Signals.soothe.emit()
	
func _start_countdown():
	countdown.show()
	countdown_timer.timeout.connect(func(): Signals.timer_expired.emit())
	countdown_timer.start(20 * 60)
	
func _process(delta: float) -> void:
	countdown.text = _format_time(countdown_timer.time_left)

func _format_time(t: float) -> String:
	var total_ms = int(t * 1000)

	var minutes = total_ms / 60000
	var seconds = (total_ms % 60000) / 1000

	return "%02d:%02d" % [minutes, seconds]
	
	
func _on_time_scale_set(scale: float) -> void:
	time_scale_value.text = "%d" % [scale]
	if scale == 1.0:
		#time_scale.hide()
		pass
	else:
		time_scale.show()


func _on_credits_pressed() -> void:
	if credits.visible:
		credits.hide()
	else:
		credits.show()


func _on_quit_pressed() -> void:
	get_tree().quit()
