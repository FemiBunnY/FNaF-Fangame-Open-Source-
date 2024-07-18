extends CharacterBody3D

signal interaction
signal interacting
signal notinteracting
signal flashlight_on
signal flashlight_off

const SPEED:int = 5

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed:float = 1
var sensitivity:float = 0.01

var is_crouching:bool = false
var is_flashlight_on:bool = false

@onready var camera_pivot = $CameraPivot
@onready var camera = $CameraPivot/Camera
@onready var crouch_shapecast = $CrouchShapecast
@onready var interaction_raycast = $CameraPivot/Camera/InteractionRaycast
@onready var flashlight = $CameraPivot/Camera/Flashlight
@onready var up_collider = $UpCollider
@onready var breath = $breath
@onready var black_screen = $"../UI/BlackScreen"

func _ready() -> void:
	#black_screen.color = Color(255,255,255,30)
	pass

func _input(event:InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camera_pivot.rotate_y(-event.relative.x * sensitivity)
			camera.rotate_x(-event.relative.y * sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta:float) -> void:
	if Input.is_action_just_pressed("crouch"):
		is_crouching = true
		breath.start()
	elif Input.is_action_just_released("crouch"):
		is_crouching = false
		breath.stop()
		
	if is_crouching == true:
		camera.position.y -= 1.5
		speed = 0.3
		up_collider.disabled = true
	elif is_crouching == false and not crouch_shapecast.is_colliding():
		camera.position.y += 1.5
		speed = 1
		up_collider.disabled = false
		#black_screen.modulate = Color(0,0,0,0)
	if not breath.is_stopped():
		pass
		#black_screen.color = Color(0,0,0,int((1 - breath.time_left / 15) * 255))
	
	camera.position.y = clamp(camera.position.y, -1.5, 1)
	
	if interaction_raycast.is_colliding() and interaction_raycast.get_collider().is_in_group("interactuable") and Input.is_action_just_pressed("interact"):
		emit_signal("interaction")
	
	if interaction_raycast.is_colliding() and interaction_raycast.get_collider().is_in_group("interactuable"):
		emit_signal("interacting")
	elif not interaction_raycast.is_colliding() or interaction_raycast.is_colliding() and  not interaction_raycast.get_collider().is_in_group("interactuable"):
		emit_signal("notinteracting")
		
	if Input.is_action_just_pressed("flash") and not is_flashlight_on:
		is_flashlight_on = true
		flashlight.light_energy = 1
		emit_signal("flashlight_on")
	elif Input.is_action_just_pressed("flash") and is_flashlight_on:
		is_flashlight_on = false
		flashlight.light_energy = 0
		emit_signal("flashlight_off")
		
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED * speed
		velocity.z = direction.z * SPEED * speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	move_and_slide()

func _on_breath_timeout():
	print("dead")
