extends Control

@onready var cross = $Crosshair

var interacting:bool = false

const CROSSHAIR_2 = preload("res://ui/crosshair_2.png")
const CROSSHAIR_1 = preload("res://ui/crosshair_1.png")

func _physics_process(delta):
	if interacting:
		cross.texture = CROSSHAIR_2
	elif not interacting:
		cross.texture = CROSSHAIR_1

func _on_player_interacting():
	interacting = true


func _on_player_notinteracting():
	interacting = false
