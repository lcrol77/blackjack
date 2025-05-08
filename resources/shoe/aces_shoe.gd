class_name AcesShoe
extends ShoeResource

func _init() -> void:
	for rank in Enums.Rank:
			cards_remaining.append(card_resource_preload.new(rank, Enums.Suit.keys()[Enums.Suit.SPADES], false))
			cards_remaining.append(card_resource_preload.new(Enums.Rank.keys()[Enums.Rank.ACE], Enums.Suit.keys()[Enums.Suit.SPADES], false))
	shuffle()
