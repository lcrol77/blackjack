class_name Player
extends Control

signal hand_changed()
signal hand_confirmed
var hand_prefab = preload("res://resources/hand.gd")
var hand: Hand
var has_bust: bool = false # flag tracking if the player has bust
var has_natural: bool = false # flag tracking if the player has a natural black jack
var bet: int
var bank_roll: int
var show_card: CardResource
var has_card_hidden: bool = false

func _ready() -> void:
	reset_player()

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
 
func get_hand_value() -> int:
	if has_bust:
		return -1 # for comparisons every hand beats this
	if has_natural:
		return 22 # idea is that naturals beat non natural 21 values
	var vals = hand.get_non_bust_values()
	assert(vals.size() >= 1, "for a hand to not be bust it must have atleast one valid non bust value")
	return vals.max()
