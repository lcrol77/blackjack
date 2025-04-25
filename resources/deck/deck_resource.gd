extends Resource
class_name DeckResource

const card_resource = preload("res://resources/card/card_resource.gd")
var cards: Array[CardResource] = []
var cards_remaining: int

func _init() -> void:
	for suit in Enums.Suit:
		for rank in Enums.Rank:
			var card: CardResource = card_resource.new(rank, suit)
			cards.append(card)
	cards_remaining = cards.size()
