class_name Viewmodel
extends Node3D

var briefcase_open: bool = false:
	set = _set_briefcase_open
var item_show: bool = false:
	set = _set_item_show
var frozen: bool = false

@onready var briefcase = $Briefcase
@onready var briefcase_anim = $Briefcase/AnimationPlayer
@onready var anim = $AnimationPlayer
@onready var hand = $Hand
@onready var hand_mesh = $Hand/MeshInstance3D

func _ready() -> void:
	Game.viewmodel = self
	Game.item_taken_out.connect(take_item_out)
	

func _physics_process(delta: float) -> void:
	if frozen:
		return
	
	if Input.is_action_just_pressed("inventory"):
		toggle_briefcase()
		if briefcase_open:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
			Game.capture_mouse = false
			Game.ui.cursor.visible = true
			Game.player.cam.frozen = true
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			Game.capture_mouse = true
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
		

func take_item_out(item: Game.ItemType, model: Mesh) -> void:
	hand_mesh.mesh = model
	item_show = not item_show
	Game.active_item  = item if item_show else Game.ItemType.NONE
	
func _set_item_show(show: bool) -> void:
	if anim.is_playing():
		return
	
	item_show = show
	if show:
		anim.play("item_show")
	else:
		anim.play("item_hide")
		
