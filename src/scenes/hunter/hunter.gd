extends CharacterBody2D

@export var speed = 200

var is_attacking = false

func get_input():
	var input_direction = Input.get_vector("hunter_left", "hunter_right", "hunter_up", "hunter_down")
	velocity = input_direction * speed

func _physics_process(delta):
	if not is_attacking:
		get_input()
		move_and_slide()

func _input(event):
	if Input.is_action_pressed("hunter_attack"):
		%Attack.show()
		is_attacking = true
		await get_tree().create_timer(1).timeout
		%Attack.hide()
		is_attacking = false
