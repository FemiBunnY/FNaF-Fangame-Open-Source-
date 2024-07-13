extends PathFollow3D

var walking:bool = false
var speed:float = 0.8

signal path_has_end

func _physics_process(delta):
	if walking:
		walk()
	
func walk():
	if progress_ratio < 1:
		progress_ratio += speed * 0.01
	elif progress_ratio >= 1:
		walking = false
		emit_signal("path_has_end")
		progress_ratio = 0

func _on_animatronico_enter_move():
	walking = true
