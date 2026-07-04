extends CharacterBody2D

@export var speed = 400
@export var acceleration_factor = 0.9
var previous_velocity := Vector2(0, 0)

func get_input():
	var input_direction = Input.get_vector("ms_left", "ms_right", "ms_up", "ms_down")
	velocity = (1 - acceleration_factor) * (input_direction * speed) + acceleration_factor * previous_velocity
	previous_velocity = velocity

func _physics_process(delta):
	get_input()
	move_and_slide()
