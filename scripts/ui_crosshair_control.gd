extends Control

signal one_hour

@onready var cross = $Crosshair
@onready var flashlight_image = $FlashlightImage
@onready var hour_label = $Hour
@onready var timer = $Hour/TenMinutes
@onready var wait_after_jumpscare = $WaitAfterJumpscare
@onready var george_jumpscare_animation = $GeorgeJumpscareAnimation
@onready var jumpscare_audio = $GeorgeJumpscareAnimation/JumpscareAudio
@onready var paul_jumpscare_animation = $PaulJumpscareAnimation
@onready var black_screen_2 = $BlackScreen2
@onready var eyes_scream = $BlackScreen2/EyesScream
@onready var eyes_jumpscare_audio = $BlackScreen2/EyesScream/EyesJumpscareAudio
@onready var visibility_timer = $BlackScreen2/EyesScream/VisibilityTimer
@onready var fullscreen_switch = $Sensitivity/VBoxContainer2/FullscreenSwitch
@onready var sensitivity_scroller = $Sensitivity/VBoxContainer2/VBoxContainer/SensitivityScroller


var interacting:bool = false

const CROSSHAIR_2 = preload("res://ui/crosshair_2.png")
const CROSSHAIR_1 = preload("res://ui/crosshair_1.png")

var hour:int = 12
var minute:int = 0

var user_prefs: UserPreferences

func _ready() -> void:
	user_prefs = UserPreferences.load_or_create()
	
	sensitivity_scroller.value = user_prefs.sensitivity
	fullscreen_switch.button_pressed = user_prefs.fullscreen
	
	if user_prefs.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif not user_prefs.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	
	george_jumpscare_animation.visible = false
	george_jumpscare_animation.stop()
	paul_jumpscare_animation.stop()
	paul_jumpscare_animation.visible = false
	
	flashlight_image.visible = false
	update_hour()
	timer.start()
	
	black_screen_2.visible = false
	eyes_scream.visible = false
	
# Interaction
func _on_player_interacting() -> void:
	cross.texture = CROSSHAIR_2

func _on_player_notinteracting() -> void:
	cross.texture = CROSSHAIR_1

# Flashlight
func _on_player_flashlight_off() -> void:
	flashlight_image.visible = false

func _on_player_flashlight_on() -> void:
	flashlight_image.visible = true

# Jumpscare
func _on_animatronic_jumpscare() -> void:
	wait_after_jumpscare.start()
	paul_jumpscare_animation.visible = true
	paul_jumpscare_animation.play()
	jumpscare_audio.play()

func _on_animatronic_george_jumpscare() -> void:
	wait_after_jumpscare.start()
	george_jumpscare_animation.visible = true
	george_jumpscare_animation.play()
	jumpscare_audio.play()

func _on_ten_minutes_timeout() -> void:
	minute += 1
	if minute >= 6:
		minute = 0
		emit_signal("one_hour")
		if hour == 12:
			hour = 1
		elif hour != 12:
			hour += 1
	update_hour()
	if hour == 6:
		get_tree().change_scene_to_file("res://scenes/six_am_screen.tscn")

func update_hour() -> void:
	hour_label.text = str(hour) + str(":") + str(minute) + str("0")


func _on_wait_after_jumpscare_timeout():
	get_tree().change_scene_to_file("res://scenes/gameover_screen.tscn")


func _on_office_pepper_jumpscare():
	black_screen_2.visible = true
	eyes_scream.visible = true
	eyes_jumpscare_audio.play()
	visibility_timer.start()
	
func _physics_process(_delta):
	if not visibility_timer.is_stopped():
		eyes_scream.modulate = Color(1,1,1,visibility_timer.time_left)

func _on_visibility_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/gameover_screen.tscn")


func _on_check_box_toggled(_toggled_on):
	if fullscreen_switch.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		user_prefs.fullscreen = true
	elif not fullscreen_switch.button_pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		user_prefs.fullscreen = false
	user_prefs.save()
	
func _on_sensitivity_scroller_drag_ended(_value_changed):
	user_prefs.sensitivity = sensitivity_scroller.value
	user_prefs.save()
