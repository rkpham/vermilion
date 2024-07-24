extends Node

enum ItemType {NONE, NOTEPAD, RECONSTRUCTOR, CHALK} 

signal player_set(player: Player)
signal item_taken_out(item: ItemType, model: Mesh)

var player: Player:
	set = _set_player
var ui: UserInterface
var viewmodel: Viewmodel
var trip_traveled: float = 0.0
var active_item: Game.ItemType = Game.ItemType.NONE

func _set_player(_player) -> void:
	player = _player
	player_set.emit(player)

func _ready() -> void:
	pass
