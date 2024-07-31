class_name NoteComponent
extends Node3D

@export_multiline var text: String

var picked_up: bool = false

@onready var writing_sound = $WritingSound

func interact() -> bool:
	if not picked_up:
		writing_sound.play()
		picked_up = true
	Game.ui.show_note(text)
	Game.note_picked_up.emit(text)
	return true
