extends Node

@export var MAX_TIME := 300.0

var bit : int
var slapped : int
var t : float

func _ready() -> void:
	$Hunter.connect("bit", bite)
	$Mosquito.connect("slapped", slap)

func bite() -> void:
	bit += 1

func slap() -> void:
	slapped += 1

func _process(delta: float) -> void:
	t += delta
	if bit + slapped > 0 or t > MAX_TIME:
		end_fight()

func start_fight() -> void:
	bit = 0
	slapped = 0

func end_fight() -> void:
	var winner_name = "Mosquito" if bit > slapped else "Hunter"
	print("%s win !" % [winner_name])
