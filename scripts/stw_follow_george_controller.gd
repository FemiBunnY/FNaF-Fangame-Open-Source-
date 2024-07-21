extends PathFollow3D

signal path_has_end

@onready var stw_footsteps_audio = $STWFootstepsAudio

var walking:bool = false

var speed:float

func _ready():
	var game = get_node("../../..")
	speed = game.george_a/10

func _physics_process(delta:float) -> void:
	if walking:
		if progress_ratio < 1:
			progress += speed * delta 
		elif progress_ratio >= 1:
			emit_signal("path_has_end")
			walking = false
			progress_ratio = 0
			stw_footsteps_audio.stop()

func _on_animatronic_george_start_move_from_stage_to_window() -> void:
	walking = true
	stw_footsteps_audio.play()

func _on_game_hour_passed():
	speed += 0.1 
