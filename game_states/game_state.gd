class_name GameState
extends Node

enum State {
	PREROUND, # Betting
	DEALING, # Dealing cards
	ACTIVE, # Players can play their turn
	DEALERTURN, # Dealer taker their turn
	ENDHAND # Players are paid out & cards are colleted
}

signal transition_requested(from: GameState, to: State)
@export var state: State
var dealer: Dealer
var players: Array[Player]
var current_player: Player
var players_to_deal: Array[Player]

func enter() -> void:
	pass

func exit() -> void:
	pass

func hit() -> void:
	pass

func stand() -> void:
	pass

func progress_turn() -> void:
	pass
