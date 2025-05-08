extends Control

@onready var dealer: Dealer = $Dealer
@onready var active_player: Player = $Player
@onready var player_label: Label = $PlayerLabel
@onready var dealer_label: Label = $DealerLabel

@export var state_machine: StateMachine 
@export var players: Array[Player] = []

func _ready() -> void:
	assert(players.size() >= 2, "Need 2 or more players") # if there is less then two you don't have a game. Need a dealer + player
	state_machine.init(dealer, players)
	active_player.hand_changed.connect(_update_label.bind(player_label, active_player))
	dealer.hand_changed.connect(_update_label.bind(dealer_label, dealer))

func _update_label(label: Label, player: Player) -> void:
	if player.has_card_hidden:
		label.text = "??"
		return
	label.text = str(player.hand.value)
	if player.hand.value != player.hand.alt_value:
		# TODO: check if val is bust
		label.text += " or "
		label.text += str(player.hand.alt_value)

func _on_stand_pressed() -> void:
	state_machine.stand()

func _on_hit_pressed() -> void:
	state_machine.hit()
