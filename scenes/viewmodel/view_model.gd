class_name Viewmodel
extends Node3D

var briefcase_open: bool = false:
	set = _set_briefcase_open
var item_show: bool = false:
	set = _set_item_show
var keyring_shown: bool = false:
	set = _set_keyring_shown
var frozen: bool = false

@onready var briefcase = $Briefcase
@onready var briefcase_anim = $Briefcase/AnimationPlayer
@onready var anim = $AnimationPlayer
@onready var key_ring_anim = $KeyRing/KeyRingAnim
@onready var hand = $Hand
@onready var hand_mesh = $Hand/MeshInstance3D
@onready var key_ring = $KeyRing

func _ready() -> void:
	Game.viewmodel = self
	Game.item_taken_out.connect(take_item_out)
	Game.put_away_item.connect(put_item_away)
	Game.object_pick_up.connect(take_object_out)
	

func _physics_process(delta: float) -> void:
	if keyring_shown:
		if anim.is_playing() or key_ring_anim.is_playing():
			return
		if Input.is_action_just_pressed("ui_cancel"):	
			keyring_shown = false
			frozen = false
		if Input.is_action_just_pressed("move_back"):
			keyring_shown = false
			frozen = false
			Game.current_key = key_ring.current_key
			Game.ui.show_dialogue("[center][color=white]Took the %s.[/color][/center]" % [key_ring.current_key])
			Game.key_changed.emit()
		if Input.is_action_just_pressed("move_forward"):
			keyring_shown = false
			frozen = false
			if Game.current_key != "":
				Game.ui.show_dialogue("[center][color=white]Returned %s.[/color][/center]" % [key_ring.current_key])
			Game.current_key = ""
			Game.key_changed.emit()
	
	if frozen:
		return
	
	if Input.is_action_just_pressed("inventory"):
		toggle_briefcase()
		if briefcase_open:
			Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
			Game.capture_mouse = false
			Game.ui.cursor.visible = true
			Game.player.cam.frozen = true
			Game.player.frozen = true
			Game.player.footsteps.stepping = false
			Game.ui.show_icon(Game.InteractType.NONE)
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			Game.capture_mouse = true
			Game.ui.cursor.visible = false
			Game.player.cam.frozen = false
			Game.player.frozen = false


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


func take_item_out(item: Game.ItemType, model: Mesh, material: StandardMaterial3D) -> void:
	hand_mesh.mesh = model
	hand_mesh.set_surface_override_material(0, material)
	item_show = not item_show
	Game.active_item  = item if item_show else Game.ItemType.NONE


func take_object_out(object: Interactable) -> void:
	hand_mesh.mesh = object.mesh.mesh
	hand_mesh.set_surface_override_material(0, object.material)
	item_show = true
	Game.active_item = Game.ItemType.WORLD_OBJECT


func put_item_away() -> void:
	hand_mesh.mesh = null
	item_show = false
	Game.active_item = Game.ItemType.NONE


func _set_item_show(show: bool) -> void:
	if anim.is_playing():
		return
		
	item_show = show
	if show:
		anim.play("item_show")
	else:
		anim.play("item_hide")


func _set_keyring_shown(show: bool) -> void:
	if anim.is_playing() or key_ring_anim.is_playing():
		return
	
	keyring_shown = show
	if show:
		briefcase_open = false
		key_ring_anim.play("key_ring_show")
		key_ring.shown = true
		Game.ui.key_ring_controls.show()
	else:
		briefcase_open = true
		key_ring_anim.play("key_ring_hide")
		key_ring.shown = false
		Game.ui.key_ring_controls.hide()
