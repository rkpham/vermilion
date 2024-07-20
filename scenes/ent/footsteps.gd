class_name Footsteps
extends Node3D

var stepping: bool = false
var step_delta: float = 0.0

@export var speed_scale: float = 1.0

@onready var step_player = $StepPlayer


func _physics_process(delta: float) -> void:
	if stepping:
		step_delta += delta * speed_scale
		if step_delta > 1.0:
			step()
	else:
		step_delta = 0.5


func step() -> void:
	step_player.play()
	step_delta = 0.0
