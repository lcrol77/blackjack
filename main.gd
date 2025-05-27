extends Control

@onready var dealer: Dealer = $Dealer
@onready var active_player: Player = $Player
@onready var player_label: Label = $PlayerLabel
@onready var dealer_label: Label = $DealerLabel
@onready var bet = $Controls/Bet
@onready var bank_roll = $BankRoll
@onready var minus: Button = $Controls/BetControls/Minus
@onready var plus: Button = $Controls/BetControls/Plus
@onready var bet_amounts: HBoxContainer = $Controls/BetAmounts

@export var state_machine: StateMachine 
@export var players: Array[Player]

var plus_active: bool = false
var minus_active: bool = false

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
	plus.pressed.connect(_on_plus_minus_toggled.bind(plus, minus))
	minus.pressed.connect(_on_plus_minus_toggled.bind(minus, plus))
	
	for child in bet_amounts.get_children():
		if child is not Button:
			continue
		assert(child.name.is_valid_int(), "please name the button with the correct numeric value")
		var button_value: int = int(child.name)
		(child as Button).pressed.connect(_on_change_bet_amount.bind(button_value))
	 
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

func _on_plus_minus_toggled(_this: Button, other: Button) -> void:
	if other.button_pressed:
		other.button_pressed = false

# TODO: move the inner logic here into the statemachine so that I can only change
# the bet amount durring the preround state
func _on_change_bet_amount(bet_amount: int) -> void:
	# TODO: when the bet amount changes with the controls I think that we want to 
	# subtract / add that amount from the bank roll. It provides better feedback to the player visually
	
	if plus.button_pressed:
		if active_player.validate_bet(bet_amount):
			print("Dont have deep enough pockets to place that bet")
			# TODO: have som kind of ui signal to indicate that a player 
			# has insufficient bank roll
			return
		active_player.bet += bet_amount
		active_player.bank_roll -= bet_amount
	elif minus.button_pressed:
		if active_player.bet - bet_amount < 0:
			# TODO: I am not sure where to put this todo yet, but 
			# the player cannot play blackjack with out a wager
			# and they need add some kind of minimum
			active_player.bet = 0
			return
		active_player.bet -= bet_amount
		active_player.bank_roll += bet_amount

func _on_deal_button_pressed() -> void:
	if active_player.bet <= 0:
		# TODO: add some visualization for this error
		print("bet must be set")
		return
	state_machine.current_state.transition_requested.emit(state_machine.current_state, GameState.State.DEALING)
