extends CharacterBody3D
class_name player

signal interaction
signal interacting
signal notinteracting

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var speed:float = 1
var sensitivity:float = 0.01
var dcampos:int
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_crouching:bool
var is_on:bool = true

@onready var camerapivot = $pivot
@onready var camera = $pivot/Camera3D
@onready var raycast = $RayCast3D
@onready var rayc = $pivot/Camera3D/rayc
@onready var flashlight = $pivot/Camera3D/SpotLight3D
@onready var collision:CollisionShape3D = $CollisionShape3D2
@onready var texture_rect = $Control/TextureRect

func _ready():
	dcampos = camera.position.y
	texture_rect.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camerapivot.rotate_y(-event.relative.x * sensitivity)
			camera.rotate_x(-event.relative.y * sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("crouch"):
		is_crouching = true
	elif Input.is_action_just_released("crouch"):
		is_crouching = false
		
	if is_crouching == true:
		camera.position.y -= 1.5
		speed = 0.3
		collision.disabled = true
	elif is_crouching == false and not raycast.is_colliding():
		camera.position.y += 1.5
		speed = 1
		collision.disabled = false
	
	camera.position.y = clamp(camera.position.y, -1.5, 1)
	
	if rayc.is_colliding() and rayc.get_collider().is_in_group("interactuable") and Input.is_action_just_pressed("interact"):
		emit_signal("interaction")
	
	if rayc.is_colliding() and rayc.get_collider().is_in_group("interactuable"):
		emit_signal("interacting")
	elif not rayc.is_colliding() or rayc.is_colliding() and  not rayc.get_collider().is_in_group("interactuable"):
		emit_signal("notinteracting")
		
	if Input.is_action_just_pressed("flash") and is_on:
		is_on = false
		flashlight.light_energy = 1
		texture_rect.visible = true
	elif Input.is_action_just_pressed("flash") and not is_on:
		is_on = true
		flashlight.light_energy = 0
		texture_rect.visible = false
		
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (camerapivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * speed
		velocity.z = direction.z * SPEED * speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()
	
