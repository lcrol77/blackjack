@tool
class_name Card
extends Sprite2D

@export var suit: Enums.Suit: set = set_suit
@export var rank: Enums.Rank: set = set_rank

const card_resource = preload("res://resources/card/card_resource.gd")
var stats: CardResource : set = set_stats

func _ready() -> void:
	stats = card_resource.new(Enums.Rank.find_key(rank), Enums.Suit.find_key(suit))

func set_stats(value: CardResource) -> void:
	stats = value
	if value == null:
		return
	if not is_node_ready():
		await ready
	region_rect.position = Vector2(stats.skin_coordinates) * 65
#region these are editor methods to make the tool script work
func set_suit(val: Enums.Suit):
	suit=val
	stats = card_resource.new(Enums.Rank.find_key(rank), Enums.Suit.find_key(suit))
func set_rank(val: Enums.Rank):
	rank=val
	stats = card_resource.new(Enums.Rank.find_key(rank), Enums.Suit.find_key(suit))
#endregion
