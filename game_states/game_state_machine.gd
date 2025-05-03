class_name StateMachine
extends Node

@export var initial_state: GameState

var current_state: GameState
var states := {}

func init(dealer: Dealer) -> void:
	for child in get_children():
		if child is GameState:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.dealer = dealer
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func hit() -> void:
	if current_state:
		current_state.hit()

func stand() -> void:
	pass


func _on_transition_requested(from: GameState, to: GameState.State):
	if from != current_state:
		return
	var new_state: GameState = states[to]
	if not new_state:
		return
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state
