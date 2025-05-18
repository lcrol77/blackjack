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
	assert(players.size() >= 1, "Need 1 or more players") # if there is less then two you don't have a game. Need a dealer + player
	state_machine.init(dealer, players)
	
	# current_player init
	active_player.hand_changed.connect(_update_label.bind(player_label, active_player, false))
	active_player.hand_confirmed.connect(_update_label.bind(player_label, active_player, true))
	active_player.bank_roll_changed.connect(_update_bank_roll)
	active_player.bet_changed.connect(_update_bet_amount)
	_update_bank_roll(active_player.bank_roll) # Initialize the bank roll to what the player currently has
	_update_bet_amount(active_player.bet)
	# dealer init
	dealer.hand_confirmed.connect(_update_label.bind(dealer_label, dealer, true))
	dealer.hand_changed.connect(_update_label.bind(dealer_label, dealer,false))

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
	if dealer.card_being_delt.is_running():
		return
	state_machine.hit()

func _on_plus_minus_toggled(this: Button, other: Button) -> void:
	if other.button_pressed:
		other.button_pressed = false

func _on_change_bet_amount(bet_amount: int) -> void:
	#TODO: add validation
	if plus.button_pressed:
		active_player.bet += bet_amount
	elif minus.button_pressed:
		active_player.bet -= bet_amount
	
