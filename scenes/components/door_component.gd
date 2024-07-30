class_name DoorComponent
extends Node3D

var can_interact: bool = true

@export var closed: bool = true
@export var locked: bool = false
@export_multiline var locked_message: String = "[center][color=white]Locked.[/color][/center]"
@export var key_name: String = "CHANGE ME"

@onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	get_parent().rotation_degrees.y = 0 if closed else 85


func interact() -> bool:
	if not can_interact:
		return true
	
	if locked and Game.current_key != key_name:
		Game.ui.show_dialogue(locked_message)
	elif locked and Game.current_key == key_name:
		Game.ui.show_dialogue("[center][color=white]The door was unlocked.[/color][/center]")
		Game.current_key = ""
		Game.key_changed.emit()
		locked = false
	else:
		can_interact = false
		if closed:
			open()
		else:
			close()
	return true


func open() -> void:
	closed = false
	anim.play("open")


func close() -> void:
	closed = true
	anim.play("close")


func allow_interrupt() -> void:
	can_interact = true
