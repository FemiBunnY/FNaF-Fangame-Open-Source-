extends Control

@onready var cross = $Crosshair
@onready var scream_image = $ScreamImage
@onready var flashlight_image = $FlashlightImage

var interacting:bool = false

const CROSSHAIR_2 = preload("res://ui/crosshair_2.png")
const CROSSHAIR_1 = preload("res://ui/crosshair_1.png")

func _ready():
	scream_image.visible = false
	flashlight_image.visible = false

# Interaction
func _on_player_interacting():
	cross.texture = CROSSHAIR_2

func _on_player_notinteracting():
	cross.texture = CROSSHAIR_1

# Flashlight
func _on_player_flashlight_off():
	flashlight_image.visible = false

func _on_player_flashlight_on():
	flashlight_image.visible = true

# Jumpscare
func _on_animatronic_jumpscare():
	scream_image.visible = true
