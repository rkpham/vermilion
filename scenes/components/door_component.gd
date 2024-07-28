class_name DoorComponent
extends Node3D

var can_interact: bool = true

@export var closed: bool = true
@export var locked: bool = false
@export_multiline var locked_message: String = "[center][color=white]Locked.[/color][/center]"

@onready var anim: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	get_parent().rotation_degrees.y = 0 if closed else 85


func interact() -> void:
	if not can_interact:
		return
	
	if locked:
		Game.ui.show_dialogue(locked_message)
	else:
		can_interact = false
		if closed:
			open()
		else:
			close()


func open() -> void:
	closed = false
	anim.play("open")


func close() -> void:
	closed = true
	anim.play("close")


func allow_interrupt() -> void:
	can_interact = true
