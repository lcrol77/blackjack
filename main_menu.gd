class_name MainMenu extends Control

const MAIN = preload("res://main.tscn")

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)

func _on_quit_pressed() -> void:
	get_tree().quit()
