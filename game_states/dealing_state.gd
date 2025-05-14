extends GameState

func enter() -> void:
	await dealer.deal_hand(players_to_deal)
	if dealer.show_card.rank == Enums.Rank.ACE:
			# TODO: ask for insurance?
			print("insurance?")
	if dealer.has_natural:
		print("dealer has a natural")
		_reveal()
		transition_requested.emit(self, GameState.State.ENDHAND)
	transition_requested.emit(self, GameState.State.ACTIVE)
