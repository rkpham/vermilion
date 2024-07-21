extends RigidBody3D

func interact():
	for child in get_children():
		if child.has_method("interact"):
			child.interact()
