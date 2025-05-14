extends GameState

func enter() -> void:
	await dealer.deal_hand(players_to_deal)
	transition_requested.emit(self, GameState.State.ACTIVE)
