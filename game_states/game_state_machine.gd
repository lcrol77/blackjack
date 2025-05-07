class_name StateMachine
extends Node

@export var initial_state: GameState

var current_state: GameState
var states := {}

func init(dealer: Dealer, players: Array[Player]) -> void:
	var children = get_children()
	for child in get_children():
		if child is GameState:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.dealer = dealer
			child.players = players
	if initial_state:
		current_state = initial_state
		initial_state.enter()

func hit() -> void:
	if current_state:
		current_state.hit()

func stand() -> void:
	if current_state:
		current_state.stand()

func _on_transition_requested(from: GameState, to: GameState.State):
	print("transitioning from ", GameState.State.keys()[from.state], " to ", GameState.State.keys()[to])
	if from != current_state:
		return
	var new_state: GameState = states[to]
	if not new_state:
		return
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state
