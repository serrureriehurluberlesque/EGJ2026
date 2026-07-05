extends Control

func _ready() -> void:
	$AnimationPlayer.play("sunset")

func _input(event):
	if Input.is_action_pressed("space"):
		get_tree().change_scene_to_file("res://scenes/fake_room/fake_room.tscn")
