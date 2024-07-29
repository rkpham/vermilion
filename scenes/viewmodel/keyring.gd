extends Node3D

var shown: bool = false

var keys: Array[Node3D] = []

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
	
	var key_idx: int = -keys.size() / 2
	for key in keys:
		var targ_rot = key_idx * 45.0
		if not key_idx == 0:
			targ_rot *= 0.5
			targ_rot += sign(key_idx) * 45
		else:
			Game.ui.key_name.text = key.key_name
		key.rotation.y = lerp_angle(key.rotation.y, deg_to_rad(targ_rot), delta * 8.0)
		key_idx += 1

func next_key() -> void:
	keys.push_back(keys.pop_front())

func prev_key() -> void:
	keys.push_front(keys.pop_back())
