class_name Player
extends Control

signal hand_changed
var hand_prefab = preload("res://resources/hand.gd")
var hand: Hand
var has_bust: bool = false
var bet: int
var has_card_hidden := false

func _ready() -> void:
	reset_player()

func hit(card: Card) -> bool:
	if card.is_face_down:
		has_card_hidden = true
	hand.add_card_to_hand(card.card_resource)
	hand_changed.emit()
	has_bust = hand.is_bust()
	return has_bust

func stand() -> void:
	# keeping around for the time being
	print("standing with ", hand.value)

func reset_player() -> void:
	hand = hand_prefab.new()
	has_bust = false
	hand_changed.emit()
