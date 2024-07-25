extends Control

var user_prefs: UserPreferences

func _ready():
	user_prefs = UserPreferences.load_or_create()
	if user_prefs.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	elif not user_prefs.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_play_button_button_up():
	get_tree().change_scene_to_file("res://scenes/game_shaded.tscn")
