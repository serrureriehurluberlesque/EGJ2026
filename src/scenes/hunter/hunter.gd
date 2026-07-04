extends CharacterBody2D

const ATTACK_DELTA = 25 # px

@export var speed = 200
@export var acceleration_factor = 0.75
var previous_velocity := Vector2(0, 0)
@export var direction: Vector2 = Vector2(1.0, 0.0)

var is_attacking = false

func get_input():
	var input_direction = Input.get_vector("hunter_left", "hunter_right", "hunter_up", "hunter_down")
	velocity = (1 - acceleration_factor) * (input_direction * speed) + acceleration_factor * previous_velocity
	previous_velocity = velocity
	
	if input_direction:
		direction = velocity.limit_length()

func _physics_process(delta):
	if not is_attacking:
		get_input()
		move_and_slide()

func _input(event):
	if Input.is_action_pressed("hunter_attack"):
		attack()
		
func attack():
	%Attack.position = ATTACK_DELTA * direction
	%Attack.show()
	is_attacking = true
	await get_tree().create_timer(1).timeout
	%Attack.hide()
	is_attacking = false
