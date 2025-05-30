extends CanvasLayer

@export var debug : bool = false
@export var side_label_node : PackedScene = preload("res://components/notification/side_label.tscn")

@onready var middle : Panel = $Middle
@onready var side : VBoxContainer = $Side

var mid_tween_reference : Tween = null

func _input(event: InputEvent) -> void:
	if event is InputEventKey and debug:
		event = (event as InputEventKey)
		if event.pressed and event.keycode == KEY_1:
			show_side()
		if event.pressed and event.keycode == KEY_2:
			show_mid()

func show_side(message : String = "Item") -> void:
	var side_label : Label = side_label_node.instantiate()
	side_label.text = message
	side.add_child(side_label)
	
	var tween : Tween = side_label.create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(side_label.queue_free)

func show_mid(message : String = "Item") -> void:
	if mid_tween_reference:
		mid_tween_reference.kill()
	middle.find_child("Label").text = message
	middle.modulate = Color(1,1,1,1)
	
	mid_tween_reference = create_tween()
	mid_tween_reference.tween_interval(2)
	mid_tween_reference.tween_property(middle, "modulate", Color(1,1,1,0),0.5)
