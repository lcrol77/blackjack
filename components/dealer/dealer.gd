class_name Dealer
extends Node

const card_prefab: PackedScene = preload("res://components/card/card.tscn")

@export var shoe: ShoeResource
@export var deal_positions: Array[Node2D] = []

var cards_to_deal: int 

func _ready() -> void:
	shoe._init()
	cards_to_deal = deal_positions.size() * 2
	Signals.deal_new_hand.connect(_deal_hand)
	Signals.clean_up_hand.connect(_clean_up_hand)

func _deal_hand() -> void:
	print("here")
	deal()

func _clean_up_hand() -> void:
	for pos: Node2D in deal_positions:
		for n in pos.get_children():
			pos.remove_child(n)
			n.queue_free()

func deal() -> void:
	var deal_index = 0
	for i in range(cards_to_deal):
		var deal_pos: Node2D = deal_positions[deal_index % deal_positions.size()]
		var card_res: CardResource = shoe.draw()
		var new_card: Card = card_prefab.instantiate()
		deal_pos.add_child(new_card)
		new_card.card_resource = card_res
		new_card.global_position = deal_pos.global_position + Vector2((65 * (i/deal_positions.size()))-32, 0)
		if i == 0:
			new_card.is_face_down = true
		deal_index+=1
