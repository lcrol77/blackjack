@tool
class_name Card
extends Node2D

@export_group("Sprites")
@export var card_front: Sprite2D
@export var card_back: Sprite2D
@export_group("Data")
@export var suit: Enums.Suit: set = set_suit
@export var rank: Enums.Rank: set = set_rank
@export var is_face_down: bool: set = set_is_face_down

const card_resource_preload = preload("res://resources/card/card_resource.gd")
var card_resource: CardResource : set = set_card_resource

func set_card_resource(value: CardResource) -> void:
	card_resource = value
	if value == null:
		return
	if not is_node_ready():
		await ready
	card_front.region_rect.position = Vector2(card_resource.skin_coordinates) * 65

func set_is_face_down(val: bool):
	is_face_down = val
	if is_face_down:
		card_front.visible = false
		card_back.visible = true
	else:
		card_front.visible = true
		card_back.visible = false

#region these are editor methods to make the tool script work
func set_suit(val: Enums.Suit):
	if Engine.is_editor_hint():
		suit=val
		_update_card_res()

func set_rank(val: Enums.Rank):
	if Engine.is_editor_hint():
		rank=val
		_update_card_res()
		
func _update_card_res() -> void:
	var res: = card_resource_preload.new()
	res.suit = suit
	res.rank = rank
	card_resource = res
#endregion
