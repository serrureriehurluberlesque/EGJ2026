extends CharacterBody2D

@export var speed = 400
@export var acceleration_factor = 0.9

var previous_velocity := Vector2(0, 0)
var human_velocity := Vector2(0, 0)
var near_human = false
var is_attacking = false

signal slapped

func _physics_process(delta):
	if not Globals.started:
		return
	get_move_input()
		
	move_and_slide()

func _input(event):
	if not Globals.started:
		return
	if Input.is_action_pressed("ms_attack"):
		attack()
		
func get_move_input():
	var input_direction = Input.get_vector("ms_left", "ms_right", "ms_up", "ms_down")
	if is_attacking:
		input_direction = Vector2()
	velocity = (1 - acceleration_factor) * (input_direction * speed) + acceleration_factor * previous_velocity
	
	if near_human:
		velocity = (human_velocity + 4 * velocity) / (1 + 4 * acceleration_factor)
	
	var rel_vel = velocity
	if near_human:
		rel_vel -= human_velocity
	
	previous_velocity = velocity
	
	
	if input_direction.length() > 0.1 or (not near_human and velocity.length() > 2.5):
		if not $AudioStreamPlayer2D.is_playing():
			$AudioStreamPlayer2D.play(randf() * 10.0)
	else:
		$AudioStreamPlayer2D.stop()
		
	human_velocity = Vector2(0, 0)
	near_human = false
		
func attack():
	if not is_attacking:
		$Attack.show()
		is_attacking = true
		$StartBite.play()
		await get_tree().create_timer(0.8).timeout
		$Bite.play()
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
	slapped.emit()

func slow(v):
	human_velocity = v
	near_human = true
