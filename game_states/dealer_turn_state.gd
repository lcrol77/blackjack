extends GameState

func enter() -> void:
	current_player = dealer
	_reveal()
	await get_tree().create_timer(2).timeout
	await take_turn()

func _hit() -> void:
	await dealer.deal_card(current_player)

func take_turn() -> void:
	while current_player.get_hand_value() < 17:
		await _hit()
		if current_player.has_bust:
			transition_requested.emit(self, State.ENDHAND)
			return
	current_player.stand()
	transition_requested.emit(self, State.ENDHAND)
