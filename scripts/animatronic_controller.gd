extends CharacterBody3D

signal enter_move_from_stage_to_window
signal enter_move_from_window_to_stage
signal enter_move_from_window_to_vent
signal enter_move_from_vent_to_office
signal jumpscare
signal idle_animation
signal walk_animation
signal window_animation
signal vent_animation

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

var animatronic_a:float

var player_on_ventilation_l:bool = false
var player_on_ventilation_r:bool = false
var player_on_ventilation_c:bool = false
var lights_on:bool = true

func _ready() -> void:
	var game = get_node("../..")
	animatronic_a  = game.paul_a/10
	
	timer.start(randf_range(5 / animatronic_a, 10 / animatronic_a))
	rotation = stw_rotation.rotation

func _on_next_movement_timeout() -> void:
	timer.stop()
	if phase == 0:
		phase = 1
		reparent(stw_follow)
		emit_signal("enter_move_from_stage_to_window")
		emit_signal("walk_animation")
	elif phase == 2:
		if player_on_ventilation_l and lights_on:
			phase = 3
			reparent(wts_follow)
			emit_signal("enter_move_from_window_to_stage")
			emit_signal("walk_animation")
		elif not lights_on and player_on_ventilation_l or not lights_on and player_on_ventilation_c:
			if animatronic_george.get_parent().name == "wtv_follow_george":
				global_position = stage.position
				reparent(stage)
				phase = 0
				timer.start(randf_range(5 / animatronic_a, 10 / animatronic_a))
				emit_signal("idle_animation")
			else:
				phase = 4
				reparent(wtv_follow)
				emit_signal("enter_move_from_window_to_vent")
				emit_signal("walk_animation")
		elif not player_on_ventilation_l:
			emit_signal("jumpscare")
			queue_free()
			
	elif phase == 5:
		global_position = ventilation.position
		rotation = ventilation.rotation
		reparent(vto_follow)
		emit_signal("enter_move_from_vent_to_office")
		emit_signal("vent_animation")
		
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
	emit_signal("window_animation")
	phase = 2
	timer.start(randf_range(3 / animatronic_a, 5 / animatronic_a))

func _on_wts_follow_path_has_end():
	reparent(stage)
	emit_signal("idle_animation")
	phase = 0
	timer.start(randf_range(5 / animatronic_a, 10 / animatronic_a))

func _on_wtv_follow_path_has_end():
	reparent(ventilation)
	phase = 5
	timer.start(randf_range(5 / animatronic_a, 10 / animatronic_a))

func _on_vto_follow_path_has_end():
	if not player_on_ventilation_c:
		emit_signal("jumpscare")
		queue_free()
	if player_on_ventilation_c:
		global_position = stage.position
		reparent(stage)
		rotation = stw_rotation.rotation
		emit_signal("idle_animation")
		phase = 0
		timer.start(randf_range(5 / animatronic_a, 10 / animatronic_a))


func _on_game_hour_passed():
	animatronic_a += 0.1
