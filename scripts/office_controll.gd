extends Node3D

@onready var light_1:OmniLight3D = $Lamps_02_001/OmniLight3D
@onready var light_2:OmniLight3D = $Lamps_02_002/OmniLight3D

var on:bool = false

func _on_player_interaction():
	if on:
		light_1.light_energy = 1
		light_2.light_energy = 1
		on = false
	elif not on:
		light_1.light_energy = 0
		light_2.light_energy = 0
		on = true
