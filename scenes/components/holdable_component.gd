class_name HoldableComponent
extends Node3D

@onready var object: Node3D = get_parent()
@export var mesh_node: Node3D


func interact():
	if Game.active_item != Game.ItemType.NONE or Game.pickup_cooldown:
		return
	Game.pickup_cooldown = true
	mesh_node.visible = false
	object.collision.disabled = true
	Game.object_pick_up.emit(object)
	Game.held_object = self
	var timer = get_tree().create_timer(0.5)
	await timer.timeout
	Game.pickup_cooldown = false

func drop(new_pos: Vector3):
	Game.put_away_item.emit()
	mesh_node.visible = true
	object.collision.disabled = false
	object.global_position = new_pos
