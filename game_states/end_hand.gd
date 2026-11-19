extends GameState

func enter()-> void:
	# determine winner
	var winners: Array[Player] = players.filter(filter_winners)
	var pushed: Array[Player] = players.filter(filter_push)
	var losers: Array[Player] = players.filter(filter_losers)
	if active_player in winners:
		Notification.show_side("You won")
	elif active_player in pushed:
		Notification.show_side("You pushed")
	else:
		Notification.show_side("You lost")
	for player in winners:
		player.bank_roll += player.bet * 2  # we get back our original wager + the wager we get from winning	
	for player in pushed:
		player.bank_roll += player.bet # adding back our pushed bet
	# clean up
	await get_tree().create_timer(2).timeout
	if active_player.bank_roll <= 0:
		Notification.show_mid("Out of money")
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://main_menu.tscn")
		return
	await dealer.reset_hand(players_to_deal)
	transition_requested.emit(self, State.PREROUND)

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
