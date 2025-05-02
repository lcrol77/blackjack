class_name GameState
extends Node

enum State {
	PREROUND, # Betting
	DEALING, # Dealing cards
	ACTIVE, # Players can play their turn
	DEALERTURN, # Dealer taker their turn
	CLEANUP # Players are paid out & cards are colleted
}
