extends Node

signal player_set(player: Player)

var player: Player:
	set = _set_player
var ui: UserInterface
var trip_traveled: float = 0.0

func _set_player(_player) -> void:
	player = _player
	player_set.emit(player)

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		#get_tree().quit()
		pass
