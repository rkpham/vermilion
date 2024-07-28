extends Area3D

@export var objects: Array[Node3D] = []


func _ready() -> void:
	for object in objects:
		object.hide()


func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		for object in objects:
			object.show()

func _on_body_exited(body: Node3D) -> void:
	if body is Player:
		for object in objects:
			object.hide()
