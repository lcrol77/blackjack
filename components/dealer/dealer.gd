class_name Dealer
extends Player

const card_prefab: PackedScene = preload("res://components/card/card.tscn")
@export var shoe: ShoeResource
@export var shoe_pos: Control
@export var discard_pos: Control
@export var offset_amount = 32

var tween: Tween

func _ready() -> void:
	super._ready()
	shoe._init()

func deal_hand(players: Array[Player]) -> void:
	var cards_to_deal = players.size() * 2
	if cards_to_deal > shoe.cards_remaining.size():
		shoe.shuffle()
	await deal(players)

func clean_up_hand(players: Array[Player]) -> void:
	for pos: Player in players:
		for card in pos.get_children():
			if card is not Card:
				continue
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
			tween.tween_property(card, "global_position", discard_pos.global_position, 0.2)
			await tween.finished
			pos.remove_child(card)
			card.queue_free()

func deal_card(player: Player) -> bool:
	var card := _spawn_card(player)
	await tween.finished
	return player.hit(card)

func deal(players: Array[Player]) -> void:
	var cards_to_deal = players.size() * 2
	for i in range(cards_to_deal):
		var normal_idx := i % players.size()
		var player: Player = players[normal_idx]
		var new_card = _spawn_card(player)
		if i == 0:
			new_card.is_face_down = true
		player.hit(new_card)
		await tween.finished

func get_card_offset(player: Player) -> Vector2:
	var count: int = 0
	for child in player.get_children():
		if child is Card:
			count += 1
	return Vector2(offset_amount*count, -offset_amount*count)

func _spawn_card(player: Player) -> Card:
	var card_res: CardResource = shoe.draw()
	var new_card: Card = card_prefab.instantiate()
	var target_position = player.global_position + get_card_offset(player)
	player.add_child(new_card)
	new_card.global_position = shoe_pos.global_position
	new_card.card_resource = card_res
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(new_card, "global_position", target_position, 0.55)
	return new_card

func reset_hand(players: Array[Player]) -> void:
	await clean_up_hand(players)
	for player in get_tree().get_nodes_in_group("players"):
		player.reset_player()
