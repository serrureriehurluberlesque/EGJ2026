extends CharacterBody2D

@export var speed = 400

func get_input():
	var input_direction = Input.get_vector("ms_left", "ms_right", "ms_up", "ms_down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()
