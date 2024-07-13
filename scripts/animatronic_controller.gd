extends CharacterBody3D

signal enter_move

@onready var timer = $next_movement

var phase:int
var player_on_ventilation_l:bool = false

func _ready():
	timer.start()
	phase = 1

func _on_next_movement_timeout():
	if phase == 1:
		print("walk to the window")
		reparent($"../stage to window/stw follow")
		emit_signal("enter_move")
	elif phase == 2:
		print("esperando para atacar o regresar")
		timer.start()
		phase = 3
	elif phase == 3:
		if player_on_ventilation_l:
			print("regret to stage")
		elif not player_on_ventilation_l:
			print("atack")
		
func _on_stw_follow_path_has_end():
	if phase == 1:
		phase = 2
		reparent($"../../../../window")
		timer.start()

func _on_ventilation_l_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		player_on_ventilation_l = true

func _on_ventilation_l_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.name == "Player":
		player_on_ventilation_l = false
