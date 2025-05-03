extends GameState

func enter() -> void:
	dealer.deal_hand()
	transition_requested.emit(self, GameState.State.ACTIVE)
