extends Node3D

@onready var anim = $AnimationPlayer

func _ready() -> void:
	anim.play("win_anim")
	Engine.time_scale = 1
	
	anim.animation_finished.connect(_on_anim_finished)

func _on_anim_finished(anim_name: String):
	get_tree().change_scene_to_file("res://scenes/main.tscn")
		
