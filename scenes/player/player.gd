class_name Player 
extends CharacterBody3D

const GRAVITY = 19.6
const SPEED = 2.0
const ACCEL = 16.0
const FRICTION = 16.0

var frozen: bool = false
var interacting: bool = false

@onready var cam: PlayerCam = $PlayerCam
@onready var interact_ray: RayCast3D = $PlayerCam/Camera3D/InteractRay
@onready var footsteps: Footsteps = $Footsteps


func _ready() -> void:
	Game.player = self


func _physics_process(delta: float) -> void:
	if frozen:
		return
	
	var input_vec = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var movement_dir = (transform.basis * Vector3(input_vec.x, 0, input_vec.y)).normalized()
	var horiz_vel = Vector2(velocity.x, velocity.z)
	var horiz_targ = Vector2(movement_dir.x, movement_dir.z)
	
	if input_vec.length_squared() > 0:
		footsteps.stepping = true
		horiz_vel = horiz_vel.move_toward(horiz_targ * SPEED, delta * ACCEL)
	else:
		footsteps.stepping = false
		horiz_vel = horiz_vel.move_toward(Vector2.ZERO, delta * FRICTION)
	
	velocity.y -= GRAVITY * delta
	velocity = Vector3(horiz_vel.x, velocity.y, horiz_vel.y)
	
	move_and_slide()
	
	var interact_hover: bool = false
	var collider
	
	if interact_ray.is_colliding():
		collider = interact_ray.get_collider()
		if collider.owner.has_method("interact"):
			interact_hover = true
			if Input.is_action_just_pressed("interact"):
				collider.owner.interact()
				interacting = true
	
	if Game.ui:
		if interact_hover and not interacting:
			Game.ui.show_icon(collider.owner.interact_type)
		else:
			Game.ui.show_icon(Values.INTERACT_TYPE.NONE)
