extends RigidBody3D

func _ready():
	$ReconstructionComponent.reconstruct()
