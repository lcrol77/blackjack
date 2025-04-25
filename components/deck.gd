class_name Deck
extends Node

@export var debugging: bool = false

var deck_resource_preload := preload("res://resources/deck/deck_resource.gd")
const card_prefab: PackedScene = preload("res://components/card/card.tscn")
var deck_resource: DeckResource


func _ready() -> void:
	deck_resource = deck_resource_preload.new()
	if get_tree().current_scene == self:
		for card_res: CardResource in deck_resource.cards:
			var card: Card = card_prefab.instantiate()
			add_child(card)
			card.card_resource = card_res
			card.global_position = Vector2((card.card_resource.rank * 65 )+ 65, (card.card_resource.suit * 65)+ 65)
	else:
		remove_child($Camera2D)
