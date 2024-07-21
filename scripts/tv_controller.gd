extends StaticBody3D

@export var material:StandardMaterial3D

@onready var timer = $TVMesh/NextInterruptionTimer
@onready var tv_mesh = $TVMesh

var time:float

func _ready():
	var game = get_node("../..")
	time = game.tv_a/10
	
	timer.start(randf_range(3 / time, 6 / time))

func _on_next_interruption_timer_timeout():
	print("timeout")
	timer.start(randf_range(3 / time, 6 / time))
	
	if material.emission_enabled == false:
		material.emission_enabled = true
