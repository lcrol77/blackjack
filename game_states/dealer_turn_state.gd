extends GameState

func enter() -> void:
	current_player = dealer
	_reveal()
	await get_tree().create_timer(2).timeout
	hit()
	transition_requested.emit(self, State.CLEANUP)

func hit()-> void:
	dealer.deal_card(current_player)

func _reveal() -> void:
	# TODO: add animations for this?
	for child in dealer.get_children():
		if child is not Card:
			continue
		var card := (child as Card)
		card.is_face_down = false
	current_player.has_card_hidden = false
	current_player.hand_changed.emit()
