class_name Dealer
extends Player

const card_prefab: PackedScene = preload("res://components/card/card.tscn")

@export var shoe: ShoeResource
@export var shoe_pos: Control
@export var discard_pos: Control
@export var deal_positions: Array[Player] = []
@export var offset_amount = 32

var current_player: int = 1
var cards_to_deal: int
var tween: Tween

func _ready() -> void:
	assert(deal_positions.size() >= 2, "Need 2 or more deal_positions") # if there is less then two you don't have a game. Need a dealer + player
	shoe._init()
	cards_to_deal = deal_positions.size() * 2

func deal_hand() -> void:
	if cards_to_deal > shoe.cards_remaining.size():
		shoe.shuffle()
	deal()

func clean_up_hand() -> void:
	for pos: Control in deal_positions:
		for card in pos.get_children():
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
			tween.tween_property(card, "global_position", discard_pos.global_position, 0.2)
			await  tween.finished
			pos.remove_child(card)
			card.queue_free()

func deal_card() -> void:
	_spawn_card(current_player)

func deal() -> void:
	var deal_index = 0
	for i in range(cards_to_deal):
		var new_card = _spawn_card(i)
		if i == 0:
			new_card.is_face_down = true
		await tween.finished

func get_card_offset(deal_pos: Player) -> Vector2:
	var num_children := deal_pos.get_child_count()
	return Vector2(offset_amount*num_children, -offset_amount*num_children)

func _spawn_card(deal_index: int) -> Card:
	var deal_pos: Control = deal_positions[deal_index % deal_positions.size()]
	var card_res: CardResource = shoe.draw()
	var new_card: Card = card_prefab.instantiate()
	var target_position = deal_pos.global_position + get_card_offset(deal_pos)
	deal_pos.add_child(new_card)
	new_card.global_position = shoe_pos.global_position
	new_card.card_resource = card_res
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(new_card, "global_position", target_position, 0.55)
	return new_card


func _on_stand_pressed() -> void:
	Signals.end_turn.emit() # emit an end turn event
