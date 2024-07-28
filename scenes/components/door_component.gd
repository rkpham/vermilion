class_name DoorComponent
extends Node3D

@export var closed: bool = true:
	set = _set_closed

@onready var anim = $AnimationPlayer
@onready var door_pivot = get_node("../../..")

func interact() -> void:
	closed = not closed

func _set_closed(set_closed: bool) -> void:
	if not is_node_ready():
		await ready
		door_pivot.rotation_degrees.y = 0 if set_closed else 85
		closed = set_closed
		return
	
	if anim.is_playing():
		if anim.current_animation_position < anim.current_animation_length * 0.6:
			return
	
	if set_closed:
		anim.play("close")
	else:
		anim.play("open")
	closed = set_closed
