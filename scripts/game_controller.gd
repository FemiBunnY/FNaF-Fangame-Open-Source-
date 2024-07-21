extends Node3D

signal hour_passed

@export var paul_a:float = 10
@export var george_a:float = 10
@export var tv_a:float = 10


func _on_ui_one_hour():
	paul_a += 0.5
	george_a += 0.5
	tv_a += 0.5
	emit_signal("hour_passed")
