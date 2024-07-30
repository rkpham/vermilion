class_name DialogueComponent
extends Node3D

enum Mode {INTERACT, INVESTIGATE}

@export var action_mode: Mode = Mode.INTERACT
@export var text = "[center][color=white][/color][/center]"

func interact() -> bool:
	if Mode.INTERACT:
		Game.ui.show_dialogue(text)
		return true
	else:
		return false

func investigate() -> bool:
	if Mode.INVESTIGATE:
		Game.ui.show_dialogue(text)
		return true
	else:
		return false
