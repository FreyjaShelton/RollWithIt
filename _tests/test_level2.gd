# How to switch to a File resource path
extends Node2D

func _on_level_switch_pressed() -> void:
  SceneSwitcher.switch_scene("res://_tests/test_level.tscn")
