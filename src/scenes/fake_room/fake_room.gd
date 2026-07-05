extends Node2D

func _ready() -> void:
	$AnimationPlayer.play("start_animation")

func begin_game() -> void:
	get_tree().change_scene_to_file("res://scenes/room/room.tscn")
