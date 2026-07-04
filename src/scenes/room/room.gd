extends Node

@export var MAX_TIME := 300.0

var bit : int
var slapped : int
var t : float

var started: bool = false
var m_ready: bool = false
var h_ready: bool = false

func _ready() -> void:
	$AnimationPlayer.play("fight_appears")

func _input(event):
	if Input.is_action_pressed("hunter_attack"):
		%HControls.text = "[center][color=red]READY[/color][/center]"
		await get_tree().create_timer(0.2).timeout
		h_ready = true
	elif Input.is_action_pressed("ms_attack"):
		%MControls.text = "[center][color=red]READY[/color][/center]"
		await get_tree().create_timer(0.2).timeout
		m_ready = true

func bite() -> void:
	bit += 1

func slap() -> void:
	slapped += 1

func _process(delta: float) -> void:
	if started:
		t += delta
		if bit + slapped > 0 or t > MAX_TIME:
			end_fight()
	elif m_ready and h_ready:
		$AnimationPlayer.play("go")

func start_fight() -> void:
	$Hunter.connect("bit", bite)
	$Mosquito.connect("slapped", slap)
	bit = 0
	slapped = 0
	started = true

func end_fight() -> void:
	print(bit, slapped)
	Globals.winner_name = "Mosquito" if bit > slapped else "Hunter"
	get_tree().change_scene_to_file("res://scenes/end/end_scene.tscn")
