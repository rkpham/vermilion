extends Node3D

var short_hand_grabbed: bool = false
var long_hand_grabbed: bool = false
var short_hand_angle: float = 0.0
var long_hand_angle: float = PI / 2.0
var got_key: bool = false
var interacting: bool = false

@onready var clock_hand_skeleton = $clockhands/ClockHandsArmature/Skeleton3D
@onready var clock_collision = $StaticBody3D/CollisionShape3D


func _input(event: InputEvent) -> void:
	if not interacting:
		return
	
	if event.is_action_released("mouse_left"):
		short_hand_grabbed = false
		long_hand_grabbed = false
		var short_hand_diff = absf(short_hand_angle - (-4.0 * PI / 6.0))
		var long_hand_diff = absf(long_hand_angle - 0.0)
		if short_hand_diff < 0.01 and long_hand_diff < 0.01:
			if not got_key:
				got_key = true
				Game.ui.show_dialogue("[center][color=yellow]Found a key from an opened compartment on the side of the clock.[/color][/center]")
				Game.viewmodel.key_ring.add_key("3-A3 Closet Key")


func _process(delta: float) -> void:
	if not interacting:
		return
	
	if short_hand_grabbed:
		var mouse_angle = (Vector2(320, 180) - Game.ui.get_global_mouse_position()).angle()
		var rounded_angle = round(mouse_angle / (PI / 6)) * (PI / 6)
		short_hand_angle = rounded_angle
		var bone_pose_rot = Quaternion.from_euler(Vector3(-rounded_angle + PI / 2.0, -PI, 0.0))
		clock_hand_skeleton.set_bone_pose_rotation(1, bone_pose_rot)
	if long_hand_grabbed:
		var mouse_angle = (Vector2(320, 180) - Game.ui.get_global_mouse_position()).angle()
		var rounded_angle = round(mouse_angle / (PI / 6)) * (PI / 6)
		long_hand_angle = rounded_angle
		var bone_pose_rot = Quaternion.from_euler(Vector3(rounded_angle - PI / 2.0, 0.0, 0.0))
		clock_hand_skeleton.set_bone_pose_rotation(0, bone_pose_rot)


func _on_short_hand_area_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("mouse_left"):
		short_hand_grabbed = true


func _on_long_hand_area_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("mouse_left"):
		long_hand_grabbed = true


func _on_close_up_component_started_closeup() -> void:
	clock_collision.disabled = true
	interacting = true


func _on_close_up_component_ended_closeup() -> void:
	clock_collision.disabled = false
	interacting = false
