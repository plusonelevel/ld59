extends Control

@onready var mainmenu = $MainMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainMenu/VBoxContainer/Play.pressed.connect(_on_play_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	mainmenu.hide()


func _on_unlock_pressed() -> void:
	Signals.hack.emit()
