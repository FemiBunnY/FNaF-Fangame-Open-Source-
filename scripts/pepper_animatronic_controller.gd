extends StaticBody3D

signal tv_on
signal tv_off

func _on_tv_tv_on():
	emit_signal("tv_on")

func _on_offic_tv_off():
	emit_signal("tv_off")

func _on_offic_tv_on():
	emit_signal("tv_on")


