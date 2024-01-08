extends Node2D

@export var level_2_scene:PackedScene

func _on_button_pressed():
	SceneSwitcher.switch_scene("res://_tests/test_level2.tscn")
