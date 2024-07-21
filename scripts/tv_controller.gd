extends StaticBody3D

@export var material:StandardMaterial3D

@onready var timer = $TVMesh/NextInterruptionTimer
@onready var tv_mesh = $TVMesh
@onready var tv_click_on_audio = $TVClickOnAudio
@onready var tv_noise_audio = $TVNoiseAudio

var time:float

func _ready():
	var game = get_node("../..")
	time = game.tv_a/10
	
	timer.start(randf_range(3 / time, 6 / time))

func _on_next_interruption_timer_timeout():
	
	if material.emission_enabled == false:
		material.emission_enabled = true
		tv_click_on_audio.play()
		tv_noise_audio.play()

func _on_offic_start_timer():
	timer.start(randf_range(3 / time, 6 / time))
