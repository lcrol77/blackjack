class_name GameState
extends Node

enum State {
	PREROUND, # Betting
	DEALING, # Dealing cards
	ACTIVE, # Players can play their turn
	DEALERTURN, # Dealer taker their turn
	CLEANUP # Players are paid out & cards are colleted
}

signal transition_requested(from: GameState, to: State)
@export var state: State
var dealer: Dealer

func enter() -> void:
	pass

func exit() -> void:
	pass

func hit() -> void:
	pass

func stand() -> void:
	pass
