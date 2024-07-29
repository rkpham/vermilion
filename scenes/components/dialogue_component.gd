class_name DialogueComponent
extends Node3D

@export var text = "[center][color=white][/color][/center]"

func interact():
	Game.ui.show_dialogue(text)
