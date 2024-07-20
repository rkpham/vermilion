class_name PlayerCam
extends Node3D

var look: Vector2 = Vector2.ZERO
var cam_copy: Camera3D:
	set = _set_cam_copy
var last_rotation: Vector3
var player
var frozen: bool = false

@export var sensitivity: float = 0.1
@export var footsteps: Footsteps
@export var view_bob_amount: float = 0.1
@export var smooth_speed: float = 24.0

@onready var cam3d = $Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if not frozen:
			event.relative *= sensitivity
			look.x -= event.relative.x
			look.y -= event.relative.y
			look.y = clamp(look.y, -89, 89)


func _process(delta: float) -> void:
	if cam_copy:
		cam3d.global_transform = cam3d.global_transform.interpolate_with(cam_copy.global_transform, delta * 16.0)
	else:
		cam3d.position = lerp(cam3d.position, Vector3.ZERO, delta * 16.0)
		cam3d.rotation.x = lerp(cam3d.rotation.x, deg_to_rad(look.y), delta * smooth_speed)
		player.rotation.y = lerp_angle(player.rotation.y, deg_to_rad(look.x), delta * smooth_speed)
	
	if footsteps:
		if footsteps.stepping:
			var bob_y = (abs(cos((footsteps.step_delta + 0.5) * PI)) * view_bob_amount) - view_bob_amount
			cam3d.position.y = bob_y
		else:
			cam3d.position.y = lerpf(cam3d.position.y, 0.0, delta * 0.01)


func _set_cam_copy(_cam_copy: Camera3D) -> void:
	cam_copy = _cam_copy
	if cam_copy:
		last_rotation = cam3d.rotation
	else:
		cam3d.rotation = last_rotation
