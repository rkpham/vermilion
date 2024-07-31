extends Node

var queue_pos: int = 0

@export var musics: Array[AudioStream] = []

@onready var audio = $AudioStreamPlayer

func _ready() -> void:
	audio.stream = musics[0]
	audio.play()

func _on_audio_stream_player_finished() -> void:
	if queue_pos < musics.size() - 1:
		queue_pos += 1
	audio.stream = musics[queue_pos]
	audio.play()
