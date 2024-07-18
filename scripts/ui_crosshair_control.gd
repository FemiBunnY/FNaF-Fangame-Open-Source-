extends Control

@onready var cross = $Crosshair
@onready var scream_image = $ScreamImage
@onready var flashlight_image = $FlashlightImage

var interacting:bool = false

const CROSSHAIR_2 = preload("res://ui/crosshair_2.png")
const CROSSHAIR_1 = preload("res://ui/crosshair_1.png")

func _ready() -> void:
	scream_image.visible = false
	flashlight_image.visible = false

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
	scream_image.visible = true
