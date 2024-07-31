class_name UserInterface
extends Control


var notepad_tween: Tween
var notepad_shown: bool = false:
	set = _set_notepad_shown
var journal_tween: Tween
var journal_shown: bool = false:
	set = _set_journal_shown
var dialogue_speaking: bool = false
var dialogue_tween: Tween
var note_tween: Tween
var note_shown: bool = false

@onready var interact_icons = $InteractIcons
@onready var cursor = $Cursor
@onready var notepad: Notepad = $Notepad
@onready var journal: Journal = $Journal
@onready var loading = $Loading
@onready var loading_progress = $Loading/LoadingProgress
@onready var dialogue = $Dialogue
@onready var dialogue_text = $Dialogue/RichTextLabel
@onready var key_ring_controls = $KeyRingControls
@onready var key_name = $KeyRingControls/KeyName
@onready var note: Note = $Note
@onready var note_text = $Note/PageText
@onready var murderer_checkbox = $MurdererSelection/Paper/VBoxContainer/Murderer
@onready var murderer_checkbox2 = $MurdererSelection/Paper/VBoxContainer/Murderer2
@onready var murderer_checkbox3 = $MurdererSelection/Paper/VBoxContainer/Murderer3


func _ready() -> void:
	Game.ui = self
	loading.show()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		cursor.global_position = event.global_position
	if event.is_action_pressed("ui_cancel"):
		if notepad_shown:
			hide_notepad()
		if journal_shown:
			hide_journal()
		if note_shown:
			hide_note()
	if event.is_action_pressed("undo"):
		if notepad_shown:
			notepad.undo()


func _physics_process(delta: float) -> void:
	if dialogue_speaking:
		if dialogue_text.visible_ratio < 1.0:
			dialogue_text.visible_characters += 1
		else:
			dialogue_speaking = false
			hide_dialogue()


func show_icon(icon_id: Game.InteractType) -> void:
	match icon_id:
		Game.InteractType.NONE:
			for icon in interact_icons.get_children():
				icon.hide()
		Game.InteractType.HAND:
			for icon in interact_icons.get_children():
				icon.hide()
			interact_icons.get_node("HandGrabIcon").show()
		Game.InteractType.EYE:
			for icon in interact_icons.get_children():
				icon.hide()
			interact_icons.get_node("EyeIcon").show()


func toggle_notepad() -> void:
	notepad_shown = not notepad_shown


func show_notepad() -> void:
	if notepad_tween:
		notepad_tween.finished.emit()
		notepad_tween.stop()
	
	notepad_tween = create_tween()
	notepad_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	notepad_tween.tween_property(notepad, "position", Vector2(200, 20), 0.5)


func hide_notepad() -> void:
	Game.viewmodel.frozen = false
	
	if notepad_tween:
		notepad_tween.finished.emit()
		notepad_tween.stop()
	
	notepad_tween = create_tween()
	notepad_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	notepad_tween.tween_property(notepad, "position", Vector2(200, 400), 0.5)


func show_journal() -> void:
	if journal_tween:
		journal_tween.finished.emit()
		journal_tween.stop()
	
	journal.show()
	journal_tween = create_tween()
	journal_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	journal_tween.tween_property(journal, "position", Vector2(0, 0), 0.5)


func hide_journal() -> void:
	Game.viewmodel.frozen = false
	
	if journal_tween:
		journal_tween.finished.emit()
		journal_tween.stop()
	
	journal_tween = create_tween()
	journal_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	journal_tween.tween_property(journal, "position", Vector2(0, 360), 0.5)
	await journal_tween.finished
	journal_tween.hide()


func set_loading_progress(progress: float) -> void:
	loading_progress.value = progress
	if progress >= 1.0:
		loading.hide()


func show_dialogue(text: String) -> void:
	if dialogue_tween:
		dialogue_tween.stop()
	
	dialogue_text.visible_ratio = 0.0
	dialogue_text.text = text
	dialogue_tween = create_tween()
	dialogue_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	dialogue_tween.tween_property(dialogue, "modulate", Color.WHITE, 0.2)
	
	await dialogue_tween.finished
	
	dialogue_speaking = true


func hide_dialogue() -> void:
	if dialogue_tween:
		dialogue_tween.stop()
	
	dialogue_tween = create_tween()
	dialogue_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	dialogue_tween.tween_property(dialogue, "position", dialogue.position, 2.0)
	dialogue_tween.tween_property(dialogue, "modulate", Color.TRANSPARENT, 0.2)


func show_note(text: String) -> void:
	if note_tween:
		note_tween.finished.emit()
		note_tween.stop()
	
	note.show()
	Game.player.frozen = true
	interact_icons.visible = false
	Game.player.cam.frozen = true
	note_text.text = text
	note_tween = create_tween()
	note_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	note_tween.tween_property(note, "position", Vector2(200, 20), 0.5)
	note_shown = true


func hide_note() -> void:
	Game.viewmodel.frozen = false
	
	if note_tween:
		note_tween.finished.emit()
		note_tween.stop()
	
	note_tween = create_tween()
	note_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	note_tween.tween_property(note, "position", Vector2(200, 400), 0.5)
	note_shown = false
	Game.player.frozen = false
	interact_icons.visible = true
	Game.player.cam.frozen = false
	await note_tween.finished
	note.hide()


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


func _on_murderer_toggled(toggled_on: bool) -> void:
	if toggled_on:
		murderer_checkbox2.button_pressed = false
		murderer_checkbox3.button_pressed = false


func _on_murderer_2_toggled(toggled_on: bool) -> void:
	if toggled_on:
		murderer_checkbox.button_pressed = false
		murderer_checkbox3.button_pressed = false


func _on_murderer_3_toggled(toggled_on: bool) -> void:
	if toggled_on:
		murderer_checkbox.button_pressed = false
		murderer_checkbox2.button_pressed = false
