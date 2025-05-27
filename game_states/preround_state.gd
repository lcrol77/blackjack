extends GameState

@onready var player_label: Label = %PlayerLabel
@onready var deal_button: Button = %DealButton
@onready var dealer_label: Label = %DealerLabel
@onready var bet_controls = %BetControls
@onready var bet_amounts = %BetAmounts
@onready var keep_bet: CheckBox = %KeepBet

func enter()-> void:
	if _is_keeping_bet():
		return
	deal_button.show()
	player_label.hide()
	dealer_label.hide()
	_toggle_bet_control_elements(false)
	
func exit() -> void:
	deal_button.hide()
	player_label.show()
	dealer_label.show()
	_toggle_bet_control_elements(true)
	
func _toggle_bet_control_elements(is_disabled: bool) -> void:
	for child in bet_amounts.get_children():
		(child as Button).disabled = is_disabled
	for child in bet_controls.get_children():
		(child as Button).disabled = is_disabled

func _is_keeping_bet() -> bool:
	if keep_bet.button_pressed:
		if active_player.bank_roll - active_player.bet < 0:
			# we dont have enough to place this bet
			print("do not have enough money to place a recurring bet")
			active_player.bet = 0
			return false
		else:
			# we do have enough money to place this bet
			active_player.bank_roll -= active_player.bet
			transition_requested.emit(self, State.DEALING)
			return true
	return false
