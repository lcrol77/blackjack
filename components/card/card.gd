@tool
class_name Card
extends Sprite2D

@export var suit: Enums.Suit: set = set_suit
@export var rank: Enums.Rank: set = set_rank

const card_resource_preload = preload("res://resources/card/card_resource.gd")
var card_resource: CardResource : set = set_card_resource

func _ready() -> void:
	if Engine.is_editor_hint():
		card_resource = card_resource_preload.new(Enums.Rank.find_key(rank), Enums.Suit.find_key(suit))

func set_card_resource(value: CardResource) -> void:
	card_resource = value
	if value == null:
		return
	if not is_node_ready():
		await ready
	region_rect.position = Vector2(card_resource.skin_coordinates) * 65

#region these are editor methods to make the tool script work
func set_suit(val: Enums.Suit):
	suit=val
	card_resource = card_resource_preload.new(Enums.Rank.find_key(rank), Enums.Suit.find_key(suit))

func set_rank(val: Enums.Rank):
	rank=val
	card_resource = card_resource_preload.new(Enums.Rank.find_key(rank), Enums.Suit.find_key(suit))
#endregion
