extends GameState

func enter()-> void:
	# determine winner
	var winners: Array[Player] = players.filter(filter_winners)
	var pushed: Array[Player] = players.filter(filter_push)
	var losers: Array[Player] = players.filter(filter_losers)
	for player in winners:
		player.bank_roll += player.bet * 2  # we get back our original wager + the wager we get from winning	
	# clean up
	await get_tree().create_timer(2).timeout
	await dealer.reset_hand(players_to_deal)
	transition_requested.emit(self, State.PREROUND) #TODO: this needs to direct to preround, but thats for later

func filter_winners(player: Player) -> bool:
	if player.has_bust:
		return false
	return player.get_hand_value() > dealer.get_hand_value()

func filter_push(player: Player) -> bool:
	if player.has_bust or dealer.has_bust:
		# we dont push busts
		return false
	return player.get_hand_value() == dealer.get_hand_value()

func filter_losers(player: Player) -> bool:
	if player.has_bust:
		return true
	return player.get_hand_value() < dealer.get_hand_value()
