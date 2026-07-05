extends CharacterBody2D

const ATTACK_DELTA = 25 # px

@export var speed = 40
@export var acceleration_factor = 0.6
var previous_velocity := Vector2(0, 0)
@export var direction: Vector2 = Vector2(1.0, 0.0)
@onready var _animated_sprite = $AnimatedSprite2D

@export var is_attacking = false
@export var is_sleeping = false
@export var is_stun = false

var face_direction := "down"
var animation_to_play := 'stand_down'
var light_fluctuation_intensity = 0
var light_fluctuation_color = 0
var auto_move = null


signal bit


func _process(delta):
	if is_sleeping:
		return
	if is_stun:
		return
	if is_attacking:
		move_animation(direction, Vector2())
	else:
		move_animation(direction, velocity)
	
	light_fluctuation_intensity += (randf() - 0.5) * 10 * delta
	light_fluctuation_color += (randf() - 0.5) * 10 * delta
	light_fluctuation_intensity = max(-1.0, min( 1.0, light_fluctuation_intensity))
	light_fluctuation_color = max(-1.0, min( 1.0, light_fluctuation_color))
	$PointLight2D.energy = 1.0 + 0.8 * light_fluctuation_intensity
	$PointLight2D.color = Color(1.0, 0.9 + 0.1 * light_fluctuation_color, 0.5 + 0.25 *  0.1 * light_fluctuation_color)
	

func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if "slow" in body:
			body.slow(velocity)
	if is_attacking:
		return
	get_move_input()
	move_and_slide()

func _input(event):
	if not Globals.started or is_sleeping or auto_move:
		return
	if Input.is_action_pressed("hunter_attack"):
		attack()

func get_move_input():
	if is_sleeping:
		return
	var input_direction = Vector2()
	if auto_move:
		if (self.position - auto_move).length() < 3.0:
			auto_move = null
		else:
			input_direction = auto_move - self.position
	elif Globals.started:
		input_direction = Input.get_vector("hunter_left", "hunter_right", "hunter_up", "hunter_down")
		if not input_direction:
			input_direction = Vector2()
	
	move(input_direction)

func move(input_direction):
	
	velocity = (1 - acceleration_factor) * (input_direction.limit_length() * speed) + acceleration_factor * previous_velocity
	previous_velocity = velocity
	
	direction = velocity.limit_length()

func move_to(pos: Vector2):
	auto_move = pos

func attack():
	$Attack.rotation = direction.angle() + PI / 2
	$AnimationPlayer.play("slap" if velocity.length() > 0.3 else "selfslap")

func selfhit():
	for body in $Attack/Area.get_overlapping_bodies():
		if "slap" in body:
			body.slap()
		if "self_slap" in body:
			body.self_slap()

func hit():
	for body in $Attack/Area.get_overlapping_bodies():
		if "slap" in body:
			body.slap()

func move_animation(direction, velocity):
	face_direction = main_direction_str(direction)
	animation_to_play = ("walk" if velocity.length() > 0.3 else "stand") + "_" +face_direction
	_animated_sprite.play(animation_to_play)
	
func main_direction_str(direction) -> String:
	if direction.length() > 0: # Check if we're moving
		if abs(direction.x) > abs(direction.y): # Horizontal or vertical? (prioritizing vertical movement)
			face_direction = "left" if direction.x < 0 else "right"
		else:
			face_direction = "up" if direction.y < 0 else "down"
	return face_direction

func biten():
	bit.emit()

func self_slap():
	print("self-slapped")
	$AnimatedSprite2D.play("stun")

func sleep():
	is_sleeping = true
	_animated_sprite.play("sleep")
	
func get_up():
	_animated_sprite.play("getup")
