extends Node3D

signal jumpscare

@onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("tv_animation")
	animation_player.speed_scale = 0

func _on_pepper_animatronic_tv_on():
	animation_player.speed_scale = 0.02


func _on_pepper_animatronic_tv_off():
	animation_player.speed_scale = 0


func _on_animation_player_animation_finished(_anim_name):
	$"../..".emit_signal("pepper_jumpscare")
