extends GameState

func enter() -> void:
	await get_tree().create_timer(2).timeout
	hit()
	transition_requested.emit(self, State.CLEANUP)

func hit()-> void:
	dealer.deal_card()
