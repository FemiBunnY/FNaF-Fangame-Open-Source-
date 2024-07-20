extends Label

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_next_blink_timer_timeout():
	if visible:
		visible = false
	elif not visible:
		visible = true

func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/gameshader.tscn")
