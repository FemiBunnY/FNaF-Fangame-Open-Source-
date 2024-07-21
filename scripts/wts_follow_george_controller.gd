extends PathFollow3D

signal path_has_end

@onready var wts_footsteps_audio = $WTSFootstepsAudio

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
			wts_footsteps_audio.stop()

func _on_animatronic_george_start_move_from_window_to_stage() -> void:
	walking = true
	wts_footsteps_audio.play()

func _on_game_hour_passed():
	var game = get_node("../../..")
	speed = game.george_a/10
