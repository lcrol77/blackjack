extends Node
var playback : AudioStreamPlaybackPolyphonic

func _enter_tree() -> void:
	var player = AudioStreamPlayer.new()
	add_child(player)

	# Create a polyphonic stream so we can play sounds directly from it
	var stream = AudioStreamPolyphonic.new()
	stream.polyphony = 32
	player.stream = stream
	player.play()
	# Get the polyphonic playback stream to play sounds
	playback = player.get_stream_playback()
	get_tree().node_added.connect(_on_node_added)

func _on_node_added(node: Node) -> void:
	if node is Button:
		node = (node as Button)
		node.pressed.connect(_button_pressed_sfx)

func _button_pressed_sfx() -> void:
	playback.play_stream(preload('res://assets/sounds/generic1.ogg'), 0, 0, randf_range(0.9, 1.1))

func play_card_sound() -> void:
	playback.play_stream(preload('res://assets/sounds/card1.ogg'), 0, 0, randf_range(0.9, 1.1))
