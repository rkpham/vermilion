extends Node

enum ItemType {NONE, NOTEPAD, JOURNAL, RECONSTRUCTOR, CHALK, WATCH, WORLD_OBJECT, KEYRING}
enum InteractType {NONE, HAND, EYE}

signal player_set(player: Player)
signal item_taken_out(item: ItemType, model: Mesh, material: StandardMaterial3D)
signal put_away_item
signal object_pick_up(object: Interactable)
signal key_changed
signal note_picked_up(text: String)

var player: Player:
	set = _set_player
var ui: UserInterface
var viewmodel: Viewmodel
var trip_traveled: float = 0.0
var active_item: Game.ItemType = Game.ItemType.NONE
var held_object: Node3D = null
var current_key: String = "None"
var capture_mouse: bool = true
var pickup_cooldown: bool = false

func _set_player(_player) -> void:
	player = _player
	player_set.emit(player)

func _ready() -> void:
	randomize()
