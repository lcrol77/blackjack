extends Control

@onready var dealer: Dealer = $Dealer
@onready var active_player: Player = $Player
@onready var label: Label = $Label
@export var state_machine: StateMachine 

func _ready() -> void:
	state_machine.init(dealer)
	active_player.hand_changed.connect(_update_label)
	label.text = str(0)
	dealer.transition_to_dealer_turn.connect(func(): state_machine.current_state.transition_requested.emit(state_machine.current_state, state_machine.current_state.State.DEALERTURN))
	
func _update_label() -> void:
	label.text = str(active_player.hand.value)
	if active_player.hand.value != active_player.hand.alt_value:
		label.text += " or "
		label.text += str(active_player.hand.alt_value)

func _on_stand_pressed() -> void:
	state_machine.stand()

func _on_hit_pressed() -> void:
	state_machine.hit()
