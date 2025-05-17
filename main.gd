extends Control

@onready var dealer: Dealer = $Dealer
@onready var active_player: Player = $Player
@onready var player_label: Label = $PlayerLabel
@onready var dealer_label: Label = $DealerLabel
@onready var bet = $Controls/Bet
@onready var bank_roll = $BankRoll

@export var state_machine: StateMachine 
@export var players: Array[Player]

func _ready() -> void:
	assert(players.size() >= 1, "Need 1 or more players") # if there is less then two you don't have a game. Need a dealer + player
	state_machine.init(dealer, players)
	active_player.hand_changed.connect(_update_label.bind(player_label, active_player, false))
	dealer.hand_changed.connect(_update_label.bind(dealer_label, dealer,false))
	active_player.hand_confirmed.connect(_update_label.bind(player_label, active_player, true))
	dealer.hand_confirmed.connect(_update_label.bind(dealer_label, dealer, true))


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

func _on_stand_pressed() -> void:
	state_machine.stand()

func _on_hit_pressed() -> void:
	if dealer.card_being_delt.is_running():
		return
	state_machine.hit()
