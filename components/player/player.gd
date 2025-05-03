class_name Player
extends Control

var hand_prefab = preload("res://resources/hand.gd")
var hand: Hand
var has_bust: bool = false
var bet: int

func _ready() -> void:
	reset_player()

func hit(card: Card) -> void:
	hand.add_card_to_hand(card.card_resource)
	if hand.is_bust():
		has_bust = true
		_end_turn()

func stand() -> void:
	_end_turn()
 
func _end_turn() -> void:
	if self.is_in_group("dealer"):
		Signals.end_hand.emit()
	else:
		Signals.end_turn.emit()

func reset_player() -> void:
	hand = hand_prefab.new()
	has_bust = false
