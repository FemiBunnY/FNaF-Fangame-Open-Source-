extends Node3D

signal lights_on
signal lights_off

@onready var light_1:OmniLight3D = $Lamps_02_001/OmniLight3D
@onready var light_2:OmniLight3D = $Lamps_02_002/OmniLight3D
@onready var swtich_audio_1 = $SwitchAudioPlayer1
@onready var swtich_audio_2 = $SwitchAudioPlayer2

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
		
