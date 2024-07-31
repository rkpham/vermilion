class_name Interactable
extends CollisionObject3D

@export var collision: CollisionShape3D 
@export var mesh_node: Node3D

var mesh: MeshInstance3D
var material: StandardMaterial3D

func _ready():
	if not mesh_node:
		return
	for child in mesh_node.get_children():
		if child is MeshInstance3D:
			mesh = child
			material = child.get_surface_override_material(0)
			break

func interact() -> void:
	var has_interacted: bool = false
	for child in get_children():
		if child.has_method("interact"):
			if await child.interact():
				has_interacted = true
	if not has_interacted:
		var roll = randi() % 2
		var text = ""
		match roll:
			0:
				text = "[center][color=white]Nothing happened.[/color][/center]"
			1:
				text = "[center][color=white]Nothing useful here.[/color][/center]"
		Game.ui.show_dialogue(text)

func investigate() -> void:
	var has_investigated: bool = false
	for child in get_children():
		if child.has_method("investigate"):
			if child.investigate():
				has_investigated = true
	if not has_investigated:
		var roll = randi() % 4
		var text = ""
		match roll:
			0:
				text = "[center][color=white]Nothing out of the ordinary.[/color][/center]"
			1:
				text = "[center][color=white]Nothing useful here.[/color][/center]"
			2:
				text = "[center][color=white]I think I should look elsewhere for any hints.[/color][/center]"
			3:
				text = "[center][color=white]I don't see anything I need.[/color][/center]"
		Game.ui.show_dialogue(text)
