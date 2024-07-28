class_name MessageArea
extends Node


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		Game.ui.show_dialogue("[center][color=white]I can't leave yet.[/color][/center]")
