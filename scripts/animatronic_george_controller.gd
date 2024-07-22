extends CharacterBody3D

signal start_move_from_stage_to_window
signal start_move_from_window_to_stage
signal start_move_from_window_to_vent
signal start_move_from_vent_to_office
signal jumpscare 
signal idle_animation
signal vent_animation
signal walking_animation
signal window_animation

var player_on_vent_r:bool = false
var player_on_vent_c:bool = false
var lights_on:bool = true

var phase:int = 0
# phase 0: stage
# phase 1: stage to window
# phase 2: window
# phase 3: window to stage
# phase 4: window to ventilation
# phase 5: entring to ventilation (break)
# phase 6: ventilation to office
# phase 7: office

var animatronic_a:float

@onready var timer = $next_movement_timer
@onready var stw_follow = $"../stage_to_window/stw_follow_george"
@onready var window = $"../../window_george"
@onready var wts_follow = $"../../window_george/window_to_stage/wts_follow_george"
@onready var stage = $".."
@onready var wtv_follow = $"../../window_george/window_to_ventilation/wtv_follow_george"
@onready var ventilation = $"../../ventilation"
@onready var vto_follow = $"../../ventilation/ventilation to office/vto_follow_george"
@onready var stw_rotation = $"../stage_rotation"
@onready var animatronic_paul = $"../../stage/Animatronic"
@onready var vent_rotation = $"../../ventilation/VentRotation"

func _ready() -> void:
	var game = get_node("../..")
	animatronic_a  = game.george_a/10
	
	timer.start(randf_range(5 / animatronic_a, 12 / animatronic_a))
	rotation = stw_rotation.rotation

func _on_next_movement_timer_timeout() -> void:
	timer.stop()
	if phase == 0:
		phase = 1
		emit_signal("start_move_from_stage_to_window")
		emit_signal("walking_animation")
		reparent(stw_follow)
	elif phase == 2:
		if player_on_vent_r and lights_on:
			print("go to stage")
			phase = 3
			reparent(wts_follow)
			emit_signal("start_move_from_window_to_stage")
			emit_signal("walking_animation")
		elif not lights_on and player_on_vent_r or not lights_on and player_on_vent_c:
			if animatronic_paul.get_parent().name == "wtv follow":
				phase = 0
				global_position = stage.position
				reparent(stage)
				emit_signal("idle_animation")
				rotation = stw_rotation.rotation
				timer.start(randf_range(5 / animatronic_a, 12 / animatronic_a))
			else:
				print("go to vent")
				phase = 4
				reparent(wtv_follow)
				emit_signal("start_move_from_window_to_vent")
				emit_signal("walking_animation")
		elif not player_on_vent_r:
			emit_signal("jumpscare")
			queue_free()
	elif phase == 5:
		phase = 6
		global_position = ventilation.position
		reparent(vto_follow)
		emit_signal("start_move_from_vent_to_office")
		emit_signal("vent_animation")
		
func _on_stw_follow_george_path_has_end() -> void:
	phase = 2
	reparent(window)
	emit_signal("window_animation")
	timer.start(randf_range(3 / animatronic_a, 6 / animatronic_a))

func _on_wts_follow_george_path_has_end() -> void:
	phase = 0
	reparent(stage)
	emit_signal("idle_animation")
	timer.start(randf_range(5 / animatronic_a, 12 / animatronic_a))

func _on_wtv_follow_george_path_has_end() -> void:
	phase = 5
	reparent(ventilation)
	rotation = vent_rotation.rotation
	timer.start(randf_range(5 / animatronic_a, 12 / animatronic_a))

func _on_vto_follow_george_path_has_end() -> void:
	if player_on_vent_c:
		rotation = stw_rotation.rotation
		phase = 0
		global_position = stage.position
		reparent(stage)
		emit_signal("idle_animation")
		timer.start(randf_range(5 / animatronic_a, 12 / animatronic_a))
	elif not player_on_vent_c:
		emit_signal("jumpscare")
		queue_free()
		phase = 6

# Booleans
func _on_ventilation_r_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index) -> void:
	if body.name == "Player":
		player_on_vent_r = true

func _on_ventilation_r_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index) -> void:
	if body.name == "Player":
		player_on_vent_r = false

func _on_ventilation_c_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index) -> void:
	if body.name == "Player":
		player_on_vent_c = true

func _on_ventilation_c_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index) -> void:
	if body.name == "Player":
		player_on_vent_c = false

func _on_office_lights_off() -> void:
	lights_on = false

func _on_office_lights_on() -> void:
	lights_on = true


func _on_game_hour_passed():
	animatronic_a += 0.1
	
