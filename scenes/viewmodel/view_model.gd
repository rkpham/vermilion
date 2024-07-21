class_name Viewmodel
extends Node3D

var briefcase_open: bool = false:
	set = _set_briefcase_open
var frozen: bool = false

@onready var briefcase = $Briefcase
@onready var briefcase_anim = $Briefcase/AnimationPlayer
@onready var anim = $AnimationPlayer


func _ready() -> void:
	Game.viewmodel = self


func _physics_process(delta: float) -> void:
	if frozen:
		return
	
	if Input.is_action_just_pressed("inventory"):
		toggle_briefcase()
		if briefcase_open:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
			Game.ui.cursor.visible = true
			Game.player.cam.frozen = true
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			Game.ui.cursor.visible = false
			Game.player.cam.frozen = false


func toggle_briefcase() -> void:
	briefcase_open = not briefcase_open


func _set_briefcase_open(open: bool) -> void:
	if anim.is_playing():
		return
	
	briefcase_open = open
	if open:
		anim.play("briefcase_open")
	else:
		anim.play("briefcase_close")


func _on_briefcase_item_input_event(camera: Node, event: InputEvent, position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event.is_action_pressed("mouse_left"):
		Game.ui.notepad_shown = true
