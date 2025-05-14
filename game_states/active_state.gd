extends GameState

var initial_index: int = 0

func enter() -> void:
	current_player = players[initial_index]

func hit()-> void:
	var is_bust = await dealer.deal_card(current_player)
	if is_bust:
		_progress_turn()

func stand() -> void:
	current_player.stand()
	_progress_turn()

func _progress_turn() -> void:
	var player_index: int = players.find(current_player)
	player_index += 1 # go to the next player
	if player_index >= players.size():
		transition_requested.emit(self, State.DEALERTURN)
		return
	current_player = players[player_index]
