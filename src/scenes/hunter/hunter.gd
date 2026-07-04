extends CharacterBody2D

const ATTACK_DELTA = 25 # px

@export var speed = 40
@export var acceleration_factor = 0.6
var previous_velocity := Vector2(0, 0)
@export var direction: Vector2 = Vector2(1.0, 0.0)
@onready var _animated_sprite = $AnimatedSprite2D

@export var is_attacking = false

var face_direction := "down"
var animation_to_play := 'stand_down'

signal bit

func get_input():
	var input_direction = Input.get_vector("hunter_left", "hunter_right", "hunter_up", "hunter_down")
	if not input_direction:
		input_direction = Vector2()
		
	velocity = (1 - acceleration_factor) * (input_direction * speed) + acceleration_factor * previous_velocity
	previous_velocity = velocity
	
	direction = velocity.limit_length()

func _process(delta):
	if is_attacking:
		move_animation(direction, Vector2())
	else:
		move_animation(direction, velocity)

func _physics_process(delta):
	if not is_attacking:
		get_input()
		move_and_slide()
	for body in $Area2D.get_overlapping_bodies():
		if "slow" in body:
			body.slow(velocity)

func _input(event):
	if Input.is_action_pressed("hunter_attack"):
		attack()
		
func attack():
	$Attack.rotation = direction.angle() + PI / 2
	$AnimationPlayer.play("slap" if velocity.length() > 0.3 else "selfslap")
	#var anim: Animation = $AnimationPlayer.get_animation("slap")
	#var track_index = anim.add_track(Animation.TYPE_VALUE)
	#anim.track_set_path(track_index, "Area:position")
	#anim.track_insert_key(track_index, 0.0, Vector2())
	#var key_id: int = anim.track_find_key(track_index, 0.6)
	#anim.track_insert_key(track_index, key_id, ATTACK_DELTA)

func selfhit():
	for body in $Attack/Area.get_overlapping_bodies():
		print(body)
		if "slap" in body:
			body.slap()
		if "self_slap" in body:
			body.self_slap()

func hit():
	for body in $Attack/Area.get_overlapping_bodies():
		print(body)
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
	print("bitten")
	bit.emit()

func self_slap():
	print("self-slapped")
