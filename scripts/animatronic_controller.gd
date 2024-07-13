extends CharacterBody3D

signal enter_move

@onready var timer = $next_movement

var phase:int
var player_on_ventilation_l:bool = false
var lights_on:bool = true

func _ready():
	timer.start()
	phase = 1

func _on_next_movement_timeout():
	if phase == 1:
		print("walk to the window")
		reparent($"../stage to window/stw follow")
		emit_signal("enter_move")
	elif phase == 2:
		pass
	elif phase == 3:
		if player_on_ventilation_l and lights_on:
			print("regret to stage")
			reparent($"../window to stage/wts follow")
			emit_signal("enter_move")
			phase = 4
		elif player_on_ventilation_l and not lights_on:
			print("go to vent")
		elif not player_on_ventilation_l:
			print("atack")
		
func _on_stw_follow_path_has_end():
	print("path has end")
	if phase == 1:
		phase = 2
		reparent($"../../../../window")
		print("esperando para atacar o regresar")
		timer.start()
		phase = 3
	elif phase == 4:
		reparent($"../../../../stage")
		phase = 1
		timer.start()

func _on_ventilation_l_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		player_on_ventilation_l = true

func _on_ventilation_l_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		player_on_ventilation_l = false

func _on_office_lights_off():
	lights_on = false

func _on_office_lights_on():
	lights_on = true

func _on_wtv_follow_path_has_end():
	pass

func _on_wts_follow_path_has_end():
	pass
