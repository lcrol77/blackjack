extends Resource
class_name ShoeResource

@export var number_of_decks: int

# preloads
const card_resource_preload = preload("res://resources/card/card_resource.gd")

var cards_remaining: Array[CardResource] = []
var played_cards: Array[CardResource] = []
var count: int
var normalized_count: float

func _init() -> void:
	# NOTE: this is okay becuase the 2 inner for loops run in constant time
	for i in number_of_decks:
		for suit in Enums.Suit.values():
			for rank in Enums.Rank.values():
				var card: CardResource = card_resource_preload.new()
				card.rank = rank
				card.suit = suit
				cards_remaining.append(card)
	shuffle()

func shuffle() -> void:
	# Empty current shoe
	for i in range(cards_remaining.size()):
		var card = cards_remaining.pop_front()
		played_cards.append(card)
	cards_remaining = played_cards
	played_cards = []
	cards_remaining.shuffle()

func draw() -> CardResource:
	var drawn_card: CardResource = cards_remaining.pop_front()
	played_cards.append(drawn_card)
	update_count(drawn_card)
	return drawn_card
	
func update_count(card: CardResource) -> void:
	if card.value >= 10:
		count +=1
	elif card.value <= 6:
		count -=1
	normalized_count = (count as float) / ((cards_remaining.size() as float)/52.0)
