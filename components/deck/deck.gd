class_name Deck
extends Node

@export var debugging: bool = false
@export var shoe: ShoeResource
const card_prefab: PackedScene = preload("res://components/card/card.tscn")


func _ready() -> void:
	shoe._init()
	if get_tree().current_scene == self:
		for card_res: CardResource in shoe.cards:
			var card: Card = card_prefab.instantiate()
			add_child(card)
			card.card_resource = card_res
			card.global_position = Vector2((card.card_resource.rank * 65 )+ 65, (card.card_resource.suit * 65)+ 65)
	else:
		remove_child($Camera2D)
