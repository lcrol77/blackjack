extends GameState

func enter()-> void:
	print("paying out...")
	await get_tree().create_timer(2).timeout
	print("payed out!")
	await dealer._end_hand()
	transition_requested.emit(self, State.DEALING) #TODO: this needs to direct to preround, but thats for later
	
