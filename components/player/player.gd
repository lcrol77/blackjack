class_name Player
extends Control

var hand_prefab = preload("res://resources/hand.gd")
var hand: Hand

func _ready() -> void:
	hand = hand_prefab.new()

func hit() -> void:
	if hand.is_bust():
		Signals.end_turn.emit()

func stand() -> void:
	Signals.end_turn.emit()
