extends Node

@onready var intro = $Intro
@onready var hover = $Hover
@onready var click = $Click

func _ready() -> void:
	intro.play()


func _on_play_mouse_entered() -> void:
	hover.play()

func _on_credits_mouse_entered() -> void:
	hover.play()
	
func _on_quit_mouse_entered() -> void:
	hover.play()

func _on_play_pressed() -> void:
	click.play()

func _on_credits_pressed() -> void:
	click.play()

func _on_quit_pressed() -> void:
	click.play()
