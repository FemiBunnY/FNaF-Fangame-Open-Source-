extends Node3D

signal lights_on
signal lights_off
signal start_timer
signal tv_on
signal tv_off
signal pepper_jumpscare

@onready var light_1:OmniLight3D = $Lamps_02_001/OmniLight3D
@onready var light_2:OmniLight3D = $Lamps_02_002/OmniLight3D
@onready var swtich_audio_1 = $SwitchAudioPlayer1
@onready var swtich_audio_2 = $SwitchAudioPlayer2
@onready var tv_click_on_audio = $TV/TVClickOnAudio
@onready var tv_click_off_audio = $TV/TVClickOffAudio
@onready var tv_noise_audio = $TV/TVNoiseAudio

@export var tv_material:StandardMaterial3D

var on:bool = false

func _on_player_interaction() -> void:
	if on:
		swtich_audio_1.play()
		light_1.light_energy = 1
		light_2.light_energy = 1
		on = false
		emit_signal("lights_on")
		
	elif not on:
		swtich_audio_2.play()
		light_1.light_energy = 0
		light_2.light_energy = 0
		on = true
		emit_signal("lights_off")
		

func _on_player_interaction_tv():
	if tv_material.emission_enabled == false:
		tv_material.emission_enabled = true
		tv_click_on_audio.play()
		tv_noise_audio.play()
		emit_signal("tv_on")
	elif tv_material.emission_enabled == true:
		tv_material.emission_enabled = false
		tv_click_off_audio.play()
		tv_noise_audio.stop()
		emit_signal("start_timer")
		emit_signal("tv_off")
