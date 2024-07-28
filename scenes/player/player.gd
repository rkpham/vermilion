class_name Player 
extends CharacterBody3D

const GRAVITY = 19.6
const SPEED = 2.0
const ACCEL = 16.0
const FRICTION = 16.0
const SPRINT_MULT = 1.4

var frozen: bool = false
var interacting: bool = false
var crafting_circle_instance : Node = null

@onready var cam: PlayerCam = $PlayerCam
@onready var interact_ray: RayCast3D = $PlayerCam/Camera3D/InteractRay
@onready var footsteps: Footsteps = $Footsteps

@onready var crafting_circle: = preload("res://scenes/crafting_circle/crafting_circle.tscn")


func _ready() -> void:
	Game.player = self
	cam.player = self


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
	var collider
	
	collider = interact_ray.get_collider()
	Game.ui.show_icon(Game.InteractType.NONE)
	
	if collider:
		if collider.has_method("interact"):
			interact_hover = true
			Game.ui.show_icon(Game.InteractType.HAND)
			if Input.is_action_just_pressed("interact"):
				collider.interact()
				interacting = true
	
	if Input.is_action_just_pressed("interact"):
		if Game.active_item == Game.ItemType.CHALK and not Game.player.cam.frozen:
			if crafting_circle_instance:
				crafting_circle_instance.erase()
			crafting_circle_instance = crafting_circle.instantiate()
			get_parent().add_child(crafting_circle_instance)
			crafting_circle_instance.global_position = Vector3(global_position.x, global_position.y - 1, global_position.z)
		
