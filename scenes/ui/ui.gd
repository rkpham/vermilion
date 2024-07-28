class_name UserInterface
extends Control


var notepad_tween: Tween
var notepad_shown: bool = false:
	set = _set_notepad_shown
var journal_tween: Tween
var journal_shown: bool = false:
	set = _set_journal_shown

@onready var interact_icons = $InteractIcons
@onready var cursor = $Cursor
@onready var notepad: Notepad = $Notepad
@onready var journal: Journal = $Journal


func _ready() -> void:
	Game.ui = self


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cursor.global_position = event.global_position
	if event.is_action_pressed("ui_cancel"):
		if notepad_shown:
			hide_notepad()
		if journal_shown:
			hide_journal()
	if event.is_action_pressed("undo"):
		if notepad_shown:
			notepad.undo()


func show_icon(icon_id: Values.INTERACT_TYPE) -> void:
	match icon_id:
		Values.INTERACT_TYPE.NONE:
			for icon in interact_icons.get_children():
				icon.hide()
		Values.INTERACT_TYPE.LOOK:
			for icon in interact_icons.get_children():
				icon.hide()
			interact_icons.get_node("EyeIcon").show()
		Values.INTERACT_TYPE.GRAB:
			for icon in interact_icons.get_children():
				icon.hide()
			interact_icons.get_node("HandGrabIcon").show()


func toggle_notepad() -> void:
	notepad_shown = not notepad_shown


func show_notepad() -> void:
	if notepad_tween:
		notepad_tween.stop()
	
	notepad_tween = create_tween()
	notepad_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	notepad_tween.tween_property(notepad, "position", Vector2(200, 20), 0.5)


func hide_notepad() -> void:
	Game.viewmodel.frozen = false
	
	if notepad_tween:
		notepad_tween.stop()
	
	notepad_tween = create_tween()
	notepad_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	notepad_tween.tween_property(notepad, "position", Vector2(200, 400), 0.5)


func show_journal() -> void:
	if journal_tween:
		journal_tween.stop()
	
	journal_tween = create_tween()
	journal_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	journal_tween.tween_property(journal, "position", Vector2(0, 0), 0.5)


func hide_journal() -> void:
	Game.viewmodel.frozen = false
	
	if journal_tween:
		journal_tween.stop()
	
	journal_tween = create_tween()
	journal_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	journal_tween.tween_property(journal, "position", Vector2(0, 360), 0.5)


func _set_notepad_shown(_notepad_shown: bool) -> void:
	notepad_shown = _notepad_shown
	
	if notepad_shown:
		show_notepad()
	else:
		hide_notepad()


func _set_journal_shown(_journal_shown: bool) -> void:
	journal_shown = _journal_shown
	
	if journal_shown:
		show_journal()
	else:
		hide_journal()
