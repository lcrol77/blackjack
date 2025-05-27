class_name Player
extends Control

signal hand_changed
signal hand_confirmed
signal bank_roll_changed(new_bank_roll)
signal bet_changed(new_bet)
var hand_prefab = preload("res://resources/hand.gd")
var hand: Hand
@onready var keep_bet: CheckBox = %KeepBet

#FIXME: move these into a player stats resource
var has_bust: bool = false # flag tracking if the player has bust
var has_natural: bool = false # flag tracking if the player has a natural black jack
var bet: int:
	set(value):
		bet = value
		bet_changed.emit(bet)
var bank_roll: int: 
	set(value):
		bank_roll = value
		bank_roll_changed.emit(bank_roll)
var show_card: CardResource
var has_card_hidden: bool = false

func _ready() -> void:
	reset_player()
	bank_roll = 500
	bet = 0

func hit(card: Card) -> bool:
	if card.is_face_down:
		has_card_hidden = true
	var card_res = card.card_resource
	if hand.cards.size() == 1:
		show_card = card_res
	hand.add_card_to_hand(card_res)
	has_bust = hand.is_bust()
	has_natural = hand.has_natural_black_jack()
	hand_changed.emit()
	return has_bust

func stand() -> void:
	# keeping around for the time being
	print("standing with ", hand.get_non_bust_values().max())
	hand_confirmed.emit()

# TODO: maybe move this to an init func?
func reset_player() -> void:
	hand = hand_prefab.new()
	has_bust = false
	has_natural = false
	has_card_hidden = false
	hand_changed.emit()
	if keep_bet.button_pressed:
		return 
	bet = 0

func get_hand_value() -> int:
	if has_bust:
		return -1 # for comparisons every hand beats this
	if has_natural:
		return 22 # idea is that naturals beat non natural 21 values
	var vals = hand.get_non_bust_values()
	assert(vals.size() >= 1, "for a hand to not be bust it must have atleast one valid non bust value")
	return vals.max()

func validate_bet(bet_amount: int) -> bool:
	return bank_roll - bet_amount < 0
		
