class_name AcesShoe
extends ShoeResource

func _init() -> void:
	for rank in Enums.Rank:
		var ace = card_resource_preload.new()
		ace.suit = Enums.Suit.SPADES
		ace.rank = Enums.Rank.ACE
		var face = card_resource_preload.new()
		face.suit = Enums.Suit.SPADES
		face.rank = Enums.Rank.KING
		cards_remaining.append(face)
		cards_remaining.append(ace)
	shuffle()
