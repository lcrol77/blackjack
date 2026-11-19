extends Control

@onready var dealer: Dealer = $Dealer
@onready var active_player: Player = $Player
@onready var player_label: Label = $PlayerLabel
@onready var dealer_label: Label = $DealerLabel
@onready var bet = $Controls/Bet
@onready var bank_roll = $BankRoll
@onready var bet_amounts: HBoxContainer = $Controls/BetAmounts
@onready var clear: Button = $Controls/Clear

@export var state_machine: StateMachine 
@export var players: Array[Player]

func _ready() -> void:
	assert(players.size() >= 1, "Need 1 or more players")
	state_machine.init(dealer, players,active_player)
	
	#region current_player init
	active_player.hand_changed.connect(_update_label.bind(player_label, active_player, false))
	active_player.hand_confirmed.connect(_update_label.bind(player_label, active_player, true))
	active_player.bank_roll_changed.connect(_update_bank_roll)
	active_player.bet_changed.connect(_update_bet_amount)
	_update_bank_roll(active_player.bank_roll) # Initialize the bank roll to what the player currently has
	_update_bet_amount(active_player.bet)
	#endregion
	#region dealer init
	dealer.hand_confirmed.connect(_update_label.bind(dealer_label, dealer, true))
	dealer.hand_changed.connect(_update_label.bind(dealer_label, dealer,false))
	#endregion
	
	for child in bet_amounts.get_children():
		if child is not Button:
			continue
		assert(child.name.is_valid_int(), "please name the button with the correct numeric value")
		var button_value: int = int(child.name)
		(child as Button).pressed.connect(_on_change_bet_amount.bind(button_value))
	clear.pressed.connect(_on_clear)

func _update_label(label: Label, player: Player, is_standing: bool) -> void:
	if player.has_card_hidden:
		label.text = "??"
		return
	if player.has_bust:
		label.text = "BUST"
		return
	var values: Array[int] = player.hand.get_non_bust_values()
	if is_standing:
		label.text = str(values.max())
		return
	var txt: String = ""
	for i in range(values.size()):
		txt += str(values[i])
		if i != values.size() -1:
			txt+= " / "
	label.text = txt

func _update_bank_roll(new_bank_roll: int)-> void:
	bank_roll.text = str(new_bank_roll)

func _update_bet_amount(bet_amt: int):
	bet.text = str(bet_amt)

func _on_stand_pressed() -> void:
	state_machine.stand()

func _on_hit_pressed() -> void:
	if dealer.card_being_delt and dealer.card_being_delt.is_running():
		return
	state_machine.hit()

func _on_change_bet_amount(bet_amount: int) -> void:
		if active_player.validate_bet(bet_amount):
			Notification.show_side("Not enough for bet")
			return
		active_player.bet += bet_amount
		active_player.bank_roll -= bet_amount
		
func _on_clear() -> void:
	var current_bet := active_player.bet
	active_player.bet = 0
	active_player.bank_roll += current_bet
	
func _on_deal_button_pressed() -> void:
	if active_player.bet <= 0:
		Notification.show_mid("Must place a bet")
		return
	state_machine.current_state.transition_requested.emit(state_machine.current_state, GameState.State.DEALING)
