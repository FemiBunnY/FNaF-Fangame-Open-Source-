extends PathFollow3D

signal path_has_end

@onready var vto_footsteps_audio = $VTOFootstepsAudio

var walking:bool = false

var speed:float

func _ready():
	var game = get_node("../../..")
	speed = game.george_a/10 / 1.5

func _physics_process(delta:float) -> void:
	if walking:
		if progress_ratio < 1:
			progress += speed * delta 
		elif progress_ratio >= 1:
			emit_signal("path_has_end")
			walking = false
			progress_ratio = 0
			vto_footsteps_audio.stop()

func _on_animatronic_george_start_move_from_vent_to_office() -> void:
	walking = true
	vto_footsteps_audio.play()

func _on_game_hour_passed():
	speed += 0.1 
