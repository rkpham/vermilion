class_name Player 
extends CharacterBody3D

const GRAVITY = 19.6
const SPEED = 2.0
const ACCEL = 16.0
const FRICTION = 16.0
const SPRINT_MULT = 1.4

var frozen: bool = false
var interacting: bool = false
var investigating: bool = false
var crafting_circle_instance : Node = null
var drawing: bool = false
var erasing: bool = false
var current_mode: Game.InteractType = Game.InteractType.HAND

@onready var cam: PlayerCam = $PlayerCam
@onready var interact_ray: RayCast3D = $PlayerCam/Camera3D/InteractRay
@onready var drop_ray: RayCast3D = $PlayerCam/Camera3D/DropRay
@onready var footsteps: Footsteps = $Footsteps

@onready var crafting_circle: = preload("res://scenes/crafting_circle/crafting_circle.tscn")


func _ready() -> void:
	Game.player = self
	cam.player = self
	cam.look.x = global_rotation_degrees.y


func _physics_process(delta: float) -> void:
	if frozen:
		return
	
	var input_vec = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_dir = (transform.basis * Vector3(input_vec.x, 0, input_vec.y)).normalized()
	var horiz_vel = Vector2(velocity.x, velocity.z)
	var horiz_targ = Vector2(movement_dir.x, movement_dir.z)
	
	var sprinting = Input.is_action_pressed("sprint")
	var speed_mult = SPRINT_MULT if sprinting else 1.0
	
	if input_vec.length_squared() > 0:
		footsteps.stepping = true
		horiz_vel = horiz_vel.move_toward(horiz_targ * SPEED * speed_mult, delta * ACCEL)
	else:
		footsteps.stepping = false
		horiz_vel = horiz_vel.move_toward(Vector2.ZERO, delta * FRICTION)
	
	velocity.y -= GRAVITY * delta
	velocity = Vector3(horiz_vel.x, velocity.y, horiz_vel.y)
	
	move_and_slide()
	
	var interact_hover: bool = false
	var investigate_hover: bool = false
	var collider
	
	collider = interact_ray.get_collider()
	Game.ui.show_icon(Game.InteractType.NONE)
	
	if collider:
		if collider.has_method("interact") and current_mode == Game.InteractType.HAND:
			interact_hover = true
			Game.ui.show_icon(Game.InteractType.HAND)
			if Input.is_action_just_pressed("interact"):
				collider.interact()
				interacting = true
		if collider.has_method("investigate") and current_mode == Game.InteractType.EYE:
			investigate_hover = true
			Game.ui.show_icon(Game.InteractType.EYE)
			if Input.is_action_just_pressed("interact"):
				collider.investigate()
				investigating = true
	
	if Input.is_action_just_pressed("interact"):
		if Game.active_item == Game.ItemType.CHALK and not Game.player.cam.frozen:
			if crafting_circle_instance and not erasing:
				erasing = true
				crafting_circle_instance.erase()
				await crafting_circle_instance.done_erasing
				erasing = false
			if not drawing:
				drawing = true
				crafting_circle_instance = crafting_circle.instantiate()
				get_parent().add_child(crafting_circle_instance)
				crafting_circle_instance.global_position = Vector3(global_position.x, global_position.y - 1, global_position.z)
				await crafting_circle_instance.done_drawing
				drawing = false
		if Game.active_item == Game.ItemType.WORLD_OBJECT and not Game.player.cam.frozen and not Game.pickup_cooldown:
			if Vector3i(drop_ray.get_collision_normal()) == Vector3i(0, 1, 0):
				Game.held_object.drop(drop_ray.get_collision_point())
	
func _input(event):	
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN) and event.is_released():
			current_mode = Game.InteractType.HAND if current_mode == Game.InteractType.EYE else Game.InteractType.EYE
