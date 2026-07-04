extends Control

func _ready() -> void:
	get_node("%" + Globals.winner_name + "Wins").show()

func _input(event):
	if Input.is_key_pressed(KEY_SPACE):
		%HunterWins.hide()
		%MosquitoWins.hide()
		get_tree().change_scene_to_file("res://scenes/room/room.tscn")
