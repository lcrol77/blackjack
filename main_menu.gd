class_name MainMenu extends Control

const MAIN = preload("res://main.tscn")

@onready var quit: Button = $Panel/MarginContainer/HBoxContainer/Quit

func _ready() -> void:
	if OS.has_feature("web"):
		quit.hide()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN)

func _on_quit_pressed() -> void:
	get_tree().quit()
