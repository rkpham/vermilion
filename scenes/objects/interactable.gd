class_name Interactable
extends CollisionObject3D

@export var collision: CollisionShape3D 
@export var mesh: MeshInstance3D

func interact():
	for child in get_children():
		if child.has_method("interact"):
			child.interact()
