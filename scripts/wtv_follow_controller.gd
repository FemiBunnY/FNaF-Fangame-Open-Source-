extends PathFollow3D

signal path_has_end

var walking:bool = false

#@onready var game = $"../../.."

var speed:float 

func _ready():
	var game = get_node("../../..")
	speed = game.paul_a/10

func _physics_process(delta:float) -> void:
	if walking:
		if progress_ratio < 1:
			progress += speed * delta 
		elif progress_ratio >= 1:
			emit_signal("path_has_end")
			walking = false
			progress_ratio = 0

func _on_animatronic_enter_move_from_window_to_vent() -> void:
	walking = true
