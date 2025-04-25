class_name Dealer
extends Node2D

const card_prefab: PackedScene = preload("res://components/card/card.tscn")

@export var shoe: ShoeResource
@export var deal_positions: Array[Node2D] = []

func _ready() -> void:
	shoe._init()
	deal()

func deal() -> void:
	var deal_index = 0
	for i in range(deal_positions.size()):
		var deal_pos: Node2D = deal_positions[deal_index % deal_positions.size()]
		var card_res: CardResource = shoe.draw()
		var new_card: Card = card_prefab.instantiate()
		new_card.card_resource = card_res
		deal_pos.add_child(new_card)
		new_card.global_position = deal_pos.global_position
		deal_index+=1
