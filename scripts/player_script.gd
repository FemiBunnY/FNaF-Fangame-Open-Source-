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
var player_on_vent:bool = false
var is_activated_flashlight:bool = false
var can_use_flashlight:bool = true

@onready var camera_pivot = $CameraPivot
@onready var camera = $CameraPivot/Camera
@onready var crouch_shapecast = $CrouchShapecast
@onready var interaction_raycast = $CameraPivot/Camera/InteractionRaycast
@onready var flashlight = $CameraPivot/Camera/Flashlight
@onready var up_collider = $UpCollider
@onready var breath = $breath
@onready var black_screen = $"../UI/BlackScreen"
@onready var flashlight_audio = $FlashlightAudio
@onready var heartbeat_audio = $HeartbeatAudio
@onready var footsteps_audio = $FootstepsAudio
@onready var footsteps_slower_audio = $FootstepsSlowerAudio
@onready var floor_raycast = $FloorRaycast
@onready var footsteps_metal_audio = $FootstepsMetalAudio
@onready var battery_timer = $CameraPivot/Camera/Flashlight/FlashlightBatteryTimer
@onready var flashlight_battery = $"../UI/FlashlightBattery"
@onready var flashlight_animations = $CameraPivot/Camera/Flashlight/FlashlightAnimations

func _ready() -> void:
	black_screen.set_color(Color(0,0,0,0))
	flashlight_animations.play("RESET")

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
	if is_activated_flashlight:
		flashlight_battery.size = Vector2(9, 34 * (battery_timer.time_left/120))
	elif not is_activated_flashlight:
		flashlight_battery.size = Vector2(9, 34)
		
	if Input.is_action_just_pressed("crouch"):
		is_crouching = true
	elif Input.is_action_just_released("crouch"):
		is_crouching = false
		
	if is_crouching == true:
		camera.position.y -= 1.5
		speed = 0.3
		up_collider.disabled = true
	elif is_crouching == false and not crouch_shapecast.is_colliding():
		camera.position.y += 1.5
		speed = 1
		up_collider.disabled = false
		breath.stop()
		if heartbeat_audio.playing == true:
			heartbeat_audio.stop()
		black_screen.set_color(Color(0,0,0,0))
	
	if not breath.is_stopped():
		black_screen.set_color(Color(0,0,0,1 - breath.time_left / 15))
		
	camera.position.y = clamp(camera.position.y, -1.5, 1)
	
	if interaction_raycast.is_colliding() and interaction_raycast.get_collider().is_in_group("interactuable") and Input.is_action_just_pressed("interact"):
		emit_signal("interaction")
	
	if interaction_raycast.is_colliding() and interaction_raycast.get_collider().is_in_group("interactuable"):
		emit_signal("interacting")
	elif not interaction_raycast.is_colliding() or interaction_raycast.is_colliding() and  not interaction_raycast.get_collider().is_in_group("interactuable"):
		emit_signal("notinteracting")
	
	if Input.is_action_just_pressed("flash") and not is_flashlight_on and can_use_flashlight:
		flashlight_audio.play()
		is_flashlight_on = true
		flashlight.light_energy = 1
		if not is_activated_flashlight:
			battery_timer.start()
			is_activated_flashlight = true
		battery_timer.paused = false
		emit_signal("flashlight_on")
	elif Input.is_action_just_pressed("flash") and is_flashlight_on:
		flashlight_audio.play()
		is_flashlight_on = false
		flashlight.light_energy = 0
		battery_timer.paused = true
		emit_signal("flashlight_off")
		
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction = (camera_pivot.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED * speed, 0.6)
		velocity.z = lerp(velocity.z, direction.z * SPEED * speed, 0.6)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if velocity:
		if floor_raycast.is_colliding() and floor_raycast.get_collider().is_in_group("concrete"):
			if is_crouching:
				if not footsteps_slower_audio.playing:
					footsteps_slower_audio.play()
				if footsteps_audio.playing:
					footsteps_audio.stop()
			elif not is_crouching:
				if footsteps_slower_audio.playing:
					footsteps_slower_audio.stop()
				if not footsteps_audio.playing:
					footsteps_audio.play()
		elif floor_raycast.is_colliding() and floor_raycast.get_collider().is_in_group("metal"):
			if not footsteps_metal_audio.playing:
					footsteps_metal_audio.play()
	elif not velocity:
		footsteps_audio.stop()
		footsteps_slower_audio.stop()
		footsteps_metal_audio.stop()
			
	move_and_slide()

func _on_breath_timeout():
	print("dead")


func _on_ventilation_c_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.name == "Player":
		player_on_vent = true
		breath.start()
		heartbeat_audio.play()

func _on_ventilation_c_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.name == "Player":
		player_on_vent = false
		
	
func _on_ventilation_l_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.name == "Player":
		player_on_vent = true
		breath.start()
		heartbeat_audio.play()

func _on_ventilation_l_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.name == "Player":
		player_on_vent = false
		print(player_on_vent)

func _on_ventilation_r_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.name == "Player":
		player_on_vent = true
		breath.start()
		heartbeat_audio.play()

func _on_ventilation_r_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if body.name == "Player":
		player_on_vent = false
		print(player_on_vent)


func _on_flashlight_battery_timer_timeout():
	can_use_flashlight = false
	battery_timer.stop()
	flashlight_animations.play("blinking")

func _on_flashlight_animations_animation_finished(_anim_name):
	is_flashlight_on = false
	flashlight.light_energy = 0
	battery_timer.paused = true
	emit_signal("flashlight_off")
