class_name NoteComponent
extends Node3D

@export_multiline var text: String

func interact():
	Game.ui.show_note(text)
	Game.note_picked_up.emit(text)
