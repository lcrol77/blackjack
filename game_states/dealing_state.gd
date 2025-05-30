extends GameState

func enter() -> void:
	await dealer.deal_hand(players_to_deal)
	if dealer.show_card.rank == Enums.Rank.ACE:
			# TODO: ask for insurance?
			Notification.show_mid("insurance?")
			await get_tree().create_timer(2).timeout
	if dealer.has_natural:
		Notification.show_mid("dealer has a natural")
		_reveal()
		await get_tree().create_timer(2).timeout
		transition_requested.emit(self, GameState.State.ENDHAND)
	transition_requested.emit(self, GameState.State.ACTIVE)
