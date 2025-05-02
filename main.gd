extends Control

@onready var dealer: Dealer = $Dealer

func _ready() -> void:
	pass

func start_turn() -> void:
	dealer.deal()

func _on_deal_pressed() -> void:
	dealer.deal_hand()

func _on_clean_up_pressed() -> void:
	dealer.clean_up_hand()
