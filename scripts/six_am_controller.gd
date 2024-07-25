extends Control

@onready var six_am_label = $VerticalContiner/SixAMLabel
@onready var fade_out_timer = $FadeOutEffect/FadeOutTimer
@onready var fade_out_effect = $FadeOutEffect

var phase:int = 0

func _ready():
	fade_out_timer.start()
	
func _process(_delta):
	if phase == 0:
		fade_out_effect.color = Color(0,0,0,fade_out_timer.time_left/3)
	elif phase == 1:
		fade_out_effect.color = Color(0,0,0,1 - fade_out_timer.time_left/3)

func _on_next_blink_timer_timeout():
	if six_am_label.modulate == Color(1,1,1,1):
		six_am_label.modulate = Color(1,1,1,0)
	elif six_am_label.modulate == Color(1,1,1,0):
		six_am_label.modulate = Color(1,1,1,1)
		

func _on_fade_out_timer_timeout():
	if phase == 0:
		phase = 1
	elif phase == 1:
		get_tree().change_scene_to_file("res://scenes/menu_screen.tscn")
