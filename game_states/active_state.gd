extends GameState

func hit()-> void:
	dealer.deal_card()

func stand() -> void:
	dealer.players[dealer.current_player].stand()
