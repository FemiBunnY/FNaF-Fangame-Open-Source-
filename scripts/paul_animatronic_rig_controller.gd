extends Node3D

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("idle")


func _on_animatronic_idle_animation():
	animation_player.play("idle")

func _on_animatronic_vent_animation():
	animation_player.play("vent")

func _on_animatronic_walk_animation():
	animation_player.play("walking")

func _on_animatronic_window_animation():
	animation_player.play("window")
