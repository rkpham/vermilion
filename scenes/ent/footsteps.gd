class_name Footsteps
extends Node3D

var stepping: bool = false
var step_delta: float = 0.0

@export var base_speed: float = 1.4
@export var speed_scale: float = 1.0

@onready var step_player = $StepPlayer


func _physics_process(delta: float) -> void:
	var owner_speed: float = 1.0
	if owner is CharacterBody3D:
		owner_speed = owner.velocity.length() / owner.SPEED
	
	if stepping:
		step_delta += delta * base_speed * speed_scale * owner_speed
		if step_delta > 1.0:
			step()
	else:
		step_delta = 0.5


func step() -> void:
	step_player.play()
	step_delta = 0.0
