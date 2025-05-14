class_name Player
extends Control

signal hand_changed()
signal hand_confirmed
var hand_prefab = preload("res://resources/hand.gd")
var hand: Hand
var has_bust: bool = false
var bet: int
var bank_roll: int
var has_card_hidden := false

func _ready() -> void:
	reset_player()

func hit(card: Card) -> bool:
	if card.is_face_down:
		has_card_hidden = true
	hand.add_card_to_hand(card.card_resource)
	has_bust = hand.is_bust()
	hand_changed.emit()
	return has_bust

func stand() -> void:
	# keeping around for the time being
	print("standing with ", hand.get_non_bust_values().max())
	hand_confirmed.emit()

func reset_player() -> void:
	hand = hand_prefab.new()
	has_bust = false
	hand_changed.emit()
 
func get_hand_value() -> int:
	if has_bust:
		return -1 # for comparisons every hand beats this
	var vals = hand.get_non_bust_values()
	assert(vals.size() >= 1, "for a hand to not be bust it must have atleast one valid non bust value")
	return vals.max()
