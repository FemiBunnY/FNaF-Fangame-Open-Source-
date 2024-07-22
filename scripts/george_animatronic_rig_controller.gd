extends Node3D

@onready var animation_player = $AnimationPlayer
@onready var stick = $rig/Skeleton3D/Stick/Stick
@onready var umbrella = $rig/Skeleton3D/Umbrella/Umbrella

func _ready():
	animation_player.play("idle")
	stick.visible = true
	umbrella.visible = true


func _on_animatronic_george_idle_animation():
	animation_player.play("idle")
	stick.visible = true
	umbrella.visible = true

func _on_animatronic_george_vent_animation():
	animation_player.play("vent")
	stick.visible = false
	umbrella.visible = false

func _on_animatronic_george_walking_animation():
	animation_player.play("walking")
	stick.visible = false
	umbrella.visible = false

func _on_animatronic_george_window_animation():
	animation_player.play("window")
	stick.visible = false
	umbrella.visible = false
