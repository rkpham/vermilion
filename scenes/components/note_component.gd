class_name NoteComponent
extends Node3D

@export_multiline var text: String

func interact() -> bool:
	Game.ui.show_note(text)
	Game.note_picked_up.emit(text)
	return true
