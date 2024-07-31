extends Node3D

const KEY_ON_RING = preload("res://scenes/viewmodel/key.tscn")

var shown: bool = false

var keys: Array[Node3D] = []
var current_key: String = ""

@onready var key_ring_model = $KeyRingModel


func _ready() -> void:
	for child in get_children():
		if child is Node3D and not child == key_ring_model:
			keys.append(child)


func _process(delta: float) -> void:
	if shown:
		if Input.is_action_just_pressed("move_left"):
			prev_key()
		if Input.is_action_just_pressed("move_right"):
			next_key()
			
	var key_idx: int = 0
	for key in keys:
		var key_idx_offset = -keys.size() / 2 + key_idx
		var targ_rot = key_idx_offset * 30.0
		if not key_idx_offset == 0:
			targ_rot *= 0.5
			targ_rot += sign(key_idx_offset) * 91
		else:
			Game.ui.key_name.text = key.key_name
			current_key = key.key_name
		
		key.rotation.y = lerp_angle(key.rotation.y, deg_to_rad(targ_rot), delta * 8.0)
		key_idx += 1


func next_key() -> void:
	keys.push_back(keys.pop_front())


func prev_key() -> void:
	keys.push_front(keys.pop_back())


func add_key(_key_name: String) -> void:
	var new_key = KEY_ON_RING.instantiate()
	add_child(new_key)
	keys.append(new_key)
	new_key.key_name = _key_name
