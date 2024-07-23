extends Control

signal one_hour

@onready var cross = $Crosshair
@onready var scream_paul = $ScreamPaul
@onready var flashlight_image = $FlashlightImage
@onready var scream_george = $ScreamGeorge
@onready var hour_label = $Hour
@onready var timer = $Hour/TenMinutes
@onready var wait_after_jumpscare = $WaitAfterJumpscare
@onready var george_jumpscare_animation = $GeorgeJumpscareAnimation
@onready var jumpscare_audio = $GeorgeJumpscareAnimation/JumpscareAudio
@onready var paul_jumpscare_animation = $PaulJumpscareAnimation

var interacting:bool = false

const CROSSHAIR_2 = preload("res://ui/crosshair_2.png")
const CROSSHAIR_1 = preload("res://ui/crosshair_1.png")

var hour:int = 12
var minute:int = 0

func _ready() -> void:
	george_jumpscare_animation.visible = false
	george_jumpscare_animation.stop()
	paul_jumpscare_animation.stop()
	paul_jumpscare_animation.visible = false
	
	scream_paul.visible = false
	scream_george.visible = false
	flashlight_image.visible = false
	update_hour()
	timer.start()

# Interaction
func _on_player_interacting() -> void:
	cross.texture = CROSSHAIR_2

func _on_player_notinteracting() -> void:
	cross.texture = CROSSHAIR_1

# Flashlight
func _on_player_flashlight_off() -> void:
	flashlight_image.visible = false
	# play audio

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
