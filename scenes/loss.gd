extends Node3D

@onready var anim = $AnimationPlayer

func _ready() -> void:
	anim.play("loss_anim")


func _on_back_to_main_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
