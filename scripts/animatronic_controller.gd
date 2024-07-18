extends CharacterBody3D

signal enter_move_from_stage_to_window
signal enter_move_from_window_to_stage
signal enter_move_from_window_to_vent
signal enter_move_from_vent_to_office
signal jumpscare

@onready var timer = $next_movement

@onready var stage = $".."
@onready var stw_follow = $"../stage to window/stw follow"
@onready var window = $"../../window"
@onready var wts_follow = $"../../window/window to stage/wts follow"
@onready var wtv_follow = $"../../window/window to ventilation/wtv follow"
@onready var ventilation = $"../../ventilation"
@onready var vto_follow = $"../../ventilation/ventilation to office/vto follow"
@onready var animatronic_george = $"../../stage_george/animatronic_george"
@onready var stw_rotation = $"../stage_rotation"

var phase:int = 0
# phase 0: stage
# phase 1: stage to window
# phase 2: window
# phase 3: window to stage
# phase 4: window to ventilation
# phase 5: entring to ventilation (break)
# phase 6: ventilation to office
# phase 7: office

var player_on_ventilation_l:bool = false
var player_on_ventilation_r:bool = false
var player_on_ventilation_c:bool = false
var lights_on:bool = true

func _ready() -> void:
	timer.start()
	rotation = stw_rotation.rotation

func _on_next_movement_timeout() -> void:
	timer.stop()
	if phase == 0:
		phase = 1
		reparent(stw_follow)
		emit_signal("enter_move_from_stage_to_window")
		print("start moving from stage to window")
	elif phase == 2:
		if player_on_ventilation_l and lights_on:
			phase = 3
			reparent(wts_follow)
			emit_signal("enter_move_from_window_to_stage")
			print("start moving from window to stage")
		elif not lights_on and player_on_ventilation_l or not lights_on and player_on_ventilation_c:
			if animatronic_george.get_parent().name == "wtv_follow_george":
				print("go back")
				global_position = stage.position
				reparent(stage)
				phase = 0
				timer.start()
				print("start timer to next check window")
			else:
				phase = 4
				reparent(wtv_follow)
				emit_signal("enter_move_from_window_to_vent")
				print("start moving from window to ventilation")
		elif not player_on_ventilation_l:
			print("attack")
			emit_signal("jumpscare")
			queue_free()
			
	elif phase == 5:
		global_position = ventilation.position
		reparent(vto_follow)
		emit_signal("enter_move_from_vent_to_office")
		print("start moving from ventilation to office")
		
# Booleans
func _on_ventilation_l_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index) -> void:
	if body.name == "Player":
		player_on_ventilation_l = true

func _on_ventilation_l_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index) -> void:
	if body.name == "Player":
		player_on_ventilation_l = false

func _on_ventilation_c_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index) -> void:
	if body.name == "Player":
		player_on_ventilation_c = true

func _on_ventilation_c_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index) -> void:
	if body.name == "Player":
		player_on_ventilation_c = false

func _on_office_lights_off() -> void:
	lights_on = false

func _on_office_lights_on() -> void:
	lights_on = true

# Signals of paths
func _on_stw_follow_path_has_end() -> void:
	reparent(window)
	phase = 2
	timer.start()
	print("start timer to know what to do")

func _on_wts_follow_path_has_end():
	reparent(stage)
	phase = 0
	timer.start()
	print("start timer to regret to window again")

func _on_wtv_follow_path_has_end():
	reparent(ventilation)
	phase = 5
	timer.start()
	print("entring in ventilation")

func _on_vto_follow_path_has_end():
	if not player_on_ventilation_c:
		print("attack")
		emit_signal("jumpscare")
		queue_free()
	if player_on_ventilation_c:
		print("go back")
		global_position = stage.position
		reparent(stage)
		rotation = stw_rotation.rotation
		phase = 0
		timer.start()
		print("start timer to next check window")
