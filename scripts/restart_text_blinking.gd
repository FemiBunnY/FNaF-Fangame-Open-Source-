extends Label

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_next_blink_timer_timeout():
	if modulate == Color(1,1,1,1):
		modulate = Color(1,1,1,0)
	elif modulate == Color(1,1,1,0):
		modulate = Color(1,1,1,1)

func _input(_event):
	if Input.is_key_pressed(KEY_R):
		get_tree().change_scene_to_file("res://scenes/game_shaded.tscn")
	elif Input.is_key_pressed(KEY_E):
		get_tree().change_scene_to_file("res://scenes/menu_screen.tscn")
