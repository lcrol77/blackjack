class_name Deck
extends Node

var deck_resource_preload := preload("res://resources/deck/deck_resource.gd")

var deck_resource: DeckResource

func _ready() -> void:
	deck_resource = deck_resource_preload.new()
