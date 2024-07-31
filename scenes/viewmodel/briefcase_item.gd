extends Area3D

var hover_tween: Tween
var debounce: float = 0.0

@export_category("Model Settings")
@export var hover_position: Vector3 = Vector3(0.0, -0.1, 0.0)
@export var item_model: Node3D
@export_category("Item Settings")
@export var item_type: Game.ItemType = Game.ItemType.NOTEPAD

@onready var hover_light: OmniLight3D = $HoverLight

signal item_used(item)

func _on_mouse_entered() -> void:
	if Game.viewmodel.frozen:
		return
	
	if hover_tween:
		hover_tween.stop()
		
	match item_type:
			Game.ItemType.NOTEPAD:
				Game.ui.show_dialogue("[center][color=white]Notepad[/color][/center]")
			Game.ItemType.JOURNAL:
				Game.ui.show_dialogue("[center][color=white]Journal[/color][/center]")
			Game.ItemType.RECONSTRUCTOR:
				Game.ui.show_dialogue("[center][color=white]Reconstructor[/color][/center]")
			Game.ItemType.KEYRING:
				Game.ui.show_dialogue("[center][color=white]Keyring[/color][/center]")
				
	hover_tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	hover_tween.tween_property(item_model, "position", hover_position, 0.2)
	hover_tween.tween_property(hover_light, "light_energy", 0.03, 0.2)
	
	await hover_tween.finished
	
	hover_light.show()


func _on_mouse_exited() -> void:
	if hover_tween:
		hover_tween.stop()
		
	hover_tween = create_tween().set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	hover_tween.tween_property(item_model, "position", Vector3.ZERO, 0.2)
	hover_tween.tween_property(hover_light, "light_energy", 0.0, 0.2)
	
	await hover_tween.finished
	
	hover_light.hide()


func _on_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("mouse_left"):
		match item_type:
			Game.ItemType.NONE:
				return
			Game.ItemType.NOTEPAD:
				_on_mouse_exited()
				Game.viewmodel.frozen = true
				Game.ui.notepad_shown = true
			Game.ItemType.JOURNAL:
				_on_mouse_exited()
				Game.viewmodel.frozen = true
				Game.ui.journal_shown = true
			Game.ItemType.RECONSTRUCTOR:
				var item_model_mesh = item_model.get_child(0).mesh
				var item_model_mat = item_model.get_child(0).get_surface_override_material(0)
				Game.item_taken_out.emit(item_type, item_model_mesh, item_model_mat)
			Game.ItemType.CHALK:
				var item_model_mesh = item_model.get_child(0).mesh
				Game.item_taken_out.emit(item_type, item_model_mesh, null)
			Game.ItemType.WATCH:
				pass
			Game.ItemType.KEYRING:
				_on_mouse_exited()
				Game.viewmodel.frozen = true
				Game.viewmodel.keyring_shown = true
				
