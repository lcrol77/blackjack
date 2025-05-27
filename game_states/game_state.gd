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
var current_player: Player # this is the player who's turn it currently is. Can be a bot or the dealer 
var active_player: Player # this is the player who is playing the game from this perspective (will be different if I decide to go multiplayer)
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

func _reveal() -> void:
	# TODO: add animations for this?
	for child in dealer.get_children():
		if child is not Card:
			continue
		var card := (child as Card)
		card.is_face_down = false
	dealer.has_card_hidden = false
	dealer.hand_changed.emit()
