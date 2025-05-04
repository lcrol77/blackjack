class_name Dealer
extends Player

const card_prefab: PackedScene = preload("res://components/card/card.tscn")
const initial_player_idx: int = 1

@export var shoe: ShoeResource
@export var shoe_pos: Control
@export var discard_pos: Control
@export var players: Array[Player] = []
@export var offset_amount = 32
@export var state_machine: StateMachine 

var current_player: int = initial_player_idx
var cards_to_deal: int
var tween: Tween


func _ready() -> void:
	super._ready()
	assert(players.size() >= 2, "Need 2 or more players") # if there is less then two you don't have a game. Need a dealer + player
	shoe._init()
	cards_to_deal = players.size() * 2
	Signals.end_turn.connect(_progress_turn)
	Signals.end_hand.connect(_end_hand)
	state_machine.init(self)

func deal_hand() -> void:
	if cards_to_deal > shoe.cards_remaining.size():
		shoe.shuffle()
	deal()

func clean_up_hand() -> void:
	for pos: Player in players:
		for card in pos.get_children():
			if card is not Card:
				continue
			var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
			tween.tween_property(card, "global_position", discard_pos.global_position, 0.2)
			await  tween.finished
			pos.remove_child(card)
			card.queue_free()

func deal_card() -> void:
	var card := _spawn_card(current_player)
	var player: Player = players[current_player]
	player.hit(card)

func on_hit() -> void:
	state_machine.hit()

func deal() -> void:
	for i in range(cards_to_deal):
		var normal_idx := _get_normalized_index(i)
		var player: Player = players[normal_idx]
		var new_card = _spawn_card(normal_idx)
		if i == 0:
			new_card.is_face_down = true
		player.hit(new_card)
		await tween.finished

# returns the rolling index, support wrap around
func _get_normalized_index(deal_index: int) -> int:
	return deal_index % players.size()

func get_card_offset(player: Player) -> Vector2:
	var count: int = 0
	for child in player.get_children():
		if child is Card:
			count += 1
			
	return Vector2(offset_amount*count, -offset_amount*count)
	
func spawn_card()-> Card:
	return _spawn_card(current_player)
	
func _spawn_card(deal_index: int) -> Card:
	var player: Player = players[deal_index]
	var card_res: CardResource = shoe.draw()
	var new_card: Card = card_prefab.instantiate()
	var target_position = player.global_position + get_card_offset(player)
	player.add_child(new_card)
	new_card.global_position = shoe_pos.global_position
	new_card.card_resource = card_res
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(new_card, "global_position", target_position, 0.55)
	return new_card
	
func _on_stand_pressed() -> void:
	state_machine.stand()

func _progress_turn() ->void:
	if current_player == 0:
		return
	current_player += 1
	if current_player == players.size():
		current_player = 0
		state_machine.current_state.transition_requested.emit(state_machine.current_state, state_machine.current_state.State.DEALERTURN)

# TODO: implement state change here
func _end_hand() -> void:
	_reset_hand()

func _reset_hand() -> void:
	clean_up_hand()
	for player in players:
		player.reset_player()
	current_player = initial_player_idx
