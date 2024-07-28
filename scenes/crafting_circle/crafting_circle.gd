extends Node3D

@onready var sprite := $Sprite3D
@onready var dust := $Dust
@onready var light := $OmniLight3D

signal done_drawing
signal done_erasing

func _ready():
	sprite.transparency = 1.0
	dust.emitting = true
	light_energy(0.0)
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(sprite, "transparency", 0.0, 0.4)
	tween.tween_method(light_energy, 0.0, 0.1, 0.4)
	await tween.finished
	done_drawing.emit()

func erase():
	var tween = get_tree().create_tween().set_parallel()
	tween.tween_property(sprite, "transparency", 1.0, 0.4)
	tween.tween_method(light_energy, 0.1, 0.0, 0.4)
	await tween.finished
	done_erasing.emit()
	queue_free()
	
func light_energy(energy: float) -> void:
	light.set_param(Light3D.PARAM_ENERGY, energy)
