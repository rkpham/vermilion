extends Area3D

enum ItemType {NOTEPAD, RECONSTRUCTOR} 

const DEBOUNCE_AMOUNT: float = 0.02

var hover_tween: Tween
var debounce: float = 0.0

@export_category("Model Settings")
@export var hover_position: Vector3 = Vector3(0.0, -0.1, 0.0)
@export var item_model: Node3D
@export_category("Item Settings")
@export var item_type: ItemType = ItemType.NOTEPAD

@onready var hover_light: OmniLight3D = $HoverLight


func _on_mouse_entered() -> void:
	if Game.viewmodel.frozen:
		return
	
	if hover_tween:
		hover_tween.stop()
	hover_tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	hover_tween.tween_property(item_model, "position", hover_position, 0.2)
	hover_tween.tween_property(hover_light, "light_energy", 0.03, 0.2)


func _on_mouse_exited() -> void:
	if hover_tween:
		hover_tween.stop()
	hover_tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	hover_tween.tween_property(item_model, "position", Vector3.ZERO, 0.2)
	hover_tween.tween_property(hover_light, "light_energy", 0.0, 0.2)


func _on_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("mouse_left"):
		match item_type:
			ItemType.NOTEPAD:
				_on_mouse_exited()
				Game.viewmodel.frozen = true
				Game.ui.notepad_shown = true
			ItemType.RECONSTRUCTOR:
				print("sdofjoasdiujf")
