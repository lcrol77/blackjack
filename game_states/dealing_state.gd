extends GameState

func enter() -> void:
	await dealer.deal_hand()
	transition_requested.emit(self, GameState.State.ACTIVE)
