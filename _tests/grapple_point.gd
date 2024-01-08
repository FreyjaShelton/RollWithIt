extends Node2D

signal grapple_point_pressed

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		emit_signal("grapple_point_pressed", global_position)
