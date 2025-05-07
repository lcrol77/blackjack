extends GameState

func enter() -> void:
	await dealer.deal_hand(players)
	transition_requested.emit(self, GameState.State.ACTIVE)
