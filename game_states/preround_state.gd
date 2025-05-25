extends GameState

@onready var player_label: Label = %PlayerLabel
@onready var deal_button: Button = %DealButton
@onready var dealer_label: Label = %DealerLabel
@onready var bet_controls = %BetControls
@onready var bet_amounts = %BetAmounts

func enter()-> void:
	deal_button.show()
	player_label.hide()
	dealer_label.hide()
	_toggle_bet_control_elements(false)
	
func exit() -> void:
	deal_button.hide()
	player_label.show()
	dealer_label.show()
	for player in players:
		player.bank_roll -= player.bet
	_toggle_bet_control_elements(true)
	
func _toggle_bet_control_elements(is_disabled: bool) -> void:
	for child in bet_amounts.get_children():
		(child as Button).disabled = is_disabled
	for child in bet_controls.get_children():
		(child as Button).disabled = is_disabled
