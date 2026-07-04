extends CharacterBody2D

@export var speed = 400
@export var acceleration_factor = 0.8

var previous_velocity := Vector2(0, 0)
var human_velocity := Vector2(0, 0)
var near_human = false
var is_attacking = false

signal slapped

func get_input():
	var input_direction = Input.get_vector("ms_left", "ms_right", "ms_up", "ms_down")
	if is_attacking:
		input_direction = Vector2()
	velocity = (1 - acceleration_factor) * (input_direction * speed) + acceleration_factor * previous_velocity
	
	if near_human:
		velocity = (human_velocity + 5 * velocity) / (1 + 5 * acceleration_factor)
		
	previous_velocity = velocity
	human_velocity = Vector2(0, 0)
	near_human = false

func _physics_process(delta):
	if Globals.started:
		get_input()
		move_and_slide()

func _input(event):
	if Input.is_action_pressed("ms_attack"):
		attack()
		
func attack():
	$Attack.show()
	is_attacking = true
	await get_tree().create_timer(0.9).timeout
	bit()
	$Attack/Impact.show()
	await get_tree().create_timer(0.1).timeout
	$Attack/Impact.hide()
	$Attack.hide()
	is_attacking = false

func bit():
	for body in $Attack/Area.get_overlapping_bodies():
		if "biten" in body:
			body.biten()

func slap():
	print("slapped")
	slapped.emit()

func slow(v):
	human_velocity = v
	near_human = true
