extends CharacterBody2D

@export var speed = 400
@export var acceleration_factor = 0.9

var previous_velocity := Vector2(0, 0)
var is_attacking = false

signal slapped

func get_input():
	var input_direction = Input.get_vector("ms_left", "ms_right", "ms_up", "ms_down")
	if is_attacking:
		input_direction = Vector2()
	velocity = (1 - acceleration_factor) * (input_direction * speed) + acceleration_factor * previous_velocity
	previous_velocity = velocity

func _physics_process(delta):
	get_input()
	move_and_slide()

func _input(event):
	if Input.is_action_pressed("ms_attack"):
		attack()
		
func attack():
	$Attack.show()
	is_attacking = true
	await get_tree().create_timer(1).timeout
	$Attack.hide()
	is_attacking = false
