extends Control

@onready var cross = $Crosshair
@onready var scream_paul = $ScreamPaul
@onready var flashlight_image = $FlashlightImage
@onready var scream_george = $ScreamGeorge
@onready var hour_label = $Hour
@onready var timer = $Hour/TenMinutes
@onready var wait_after_jumpscare = $WaitAfterJumpscare

var interacting:bool = false

const CROSSHAIR_2 = preload("res://ui/crosshair_2.png")
const CROSSHAIR_1 = preload("res://ui/crosshair_1.png")

var hour:int = 12
var minute:int = 0

func _ready() -> void:
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
	scream_paul.visible = true
	wait_after_jumpscare.start()

func _on_animatronic_george_jumpscare() -> void:
	scream_george.visible = true
	wait_after_jumpscare.start()

func _on_ten_minutes_timeout() -> void:
	minute += 1
	if minute >= 6:
		minute = 0
		if hour == 12:
			hour = 1
		elif hour != 12:
			hour += 1
	update_hour()

func update_hour() -> void:
	hour_label.text = str(hour) + str(":") + str(minute) + str("0")


func _on_wait_after_jumpscare_timeout():
	get_tree().change_scene_to_file("res://scenes/gameover_screen.tscn")
