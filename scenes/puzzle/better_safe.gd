class_name BetterSafe
extends Node3D

@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var safe_buttons: Node3D = $safe/Armature/Skeleton3D/BoneAttachment3D/SafeButtons
@onready var label: Label3D = $safe/Armature/Skeleton3D/BoneAttachment3D/Label3D
@onready var open_sound = $OpenSound
@onready var click_sound = $ClickSound
@export var password: String = "7799338"

func _ready():
	for button in safe_buttons.get_children():
		button.number_pressed.connect(_get_number)


func _get_number(number: int, submit: bool, clear: bool) -> void:
	click_sound.play()
	
	if submit:
		if label.text == password:
			label.modulate = Color(0.0, 1.0, 0.0)
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			Game.capture_mouse = true
			Game.ui.cursor.visible = false
			var timer = get_tree().create_timer(0.5)
			await timer.timeout
			Game.player.cam.cam_copy = null
			Game.player.frozen = false
			Game.viewmodel.frozen = false
			Game.ui.interact_icons.visible = true
			anim.play("safe_open")
			open_sound.play()
		else:
			label.modulate = Color(1.0, 0.0, 0.0)
	elif clear:
		label.text = ""
		label.modulate = Color(1.0, 1.0, 1.0)
	elif label.text.length() == 7:
		label.text = label.text.substr(1) + "%d" % number
		label.modulate = Color(1.0, 1.0, 1.0)
	else:
		label.text += "%d" % number
		label.modulate = Color(1.0, 1.0, 1.0)
