extends StaticBody3D

signal interaction
signal interacting
signal notinteracting

var sensitivity:float # = 0.015

var mouse_visible:bool = false

@onready var camera_pivot = $NeckPivot
@onready var camera = $NeckPivot/Camera
@onready var interaction_raycast = $NeckPivot/Camera/InteractionRaycast
@onready var sensitivity_ui = $CanvasLayer/Sensitivity
@onready var sensitivity_scroller = $CanvasLayer/Sensitivity/VBoxContainer2/VBoxContainer/SensitivityScroller

var user_prefs: UserPreferences

func _ready() -> void:
	user_prefs = UserPreferences.load_or_create()
	sensitivity = float(user_prefs.sensitivity)/1000
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	sensitivity_ui.visible = false
	sensitivity = sensitivity_scroller.value/1000
	
func _input(event:InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and not mouse_visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		sensitivity_ui.visible = true
		mouse_visible = true
	elif event.is_action_pressed("ui_cancel") and mouse_visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		sensitivity_ui.visible = false
		mouse_visible = false
		
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camera_pivot.rotate_y(-event.relative.x * sensitivity)
			camera.rotate_x(-event.relative.y * sensitivity)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
			
func _physics_process(_delta) -> void:
	camera.position.y = clamp(camera.position.y, -1.5, 1)
	
	if interaction_raycast.is_colliding() and interaction_raycast.get_collider().is_in_group("interactuable") and Input.is_action_just_pressed("interact"):
		pass
	
	if interaction_raycast.is_colliding() and interaction_raycast.get_collider().is_in_group("interactuable"):
		emit_signal("interacting")
	elif not interaction_raycast.is_colliding() or interaction_raycast.is_colliding() and  not interaction_raycast.get_collider().is_in_group("interactuable"):
		emit_signal("notinteracting")
	

func _on_sensitivity_scroller_drag_ended(_value_changed):
	sensitivity = sensitivity_scroller.value/1000
	
