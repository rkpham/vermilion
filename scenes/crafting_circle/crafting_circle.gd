extends Node3D

@onready var sprite := $Sprite3D
@onready var dust := $Dust

func _ready():
	sprite.transparency = 1.0
	dust.emitting = true
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "transparency", 0.0, 0.2)

func erase():
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "transparency", 1.0, 0.2)
	await tween.finished
	queue_free()
