extends Control

@onready var dealer: Dealer = $Dealer
@onready var active_player: Player = $Player
@onready var label: Label = $Label

func _ready() -> void:
	active_player.hand_changed.connect(_update_label)
	label.text = str(0)
	
func start_turn() -> void:
	dealer.deal()

func _on_deal_pressed() -> void:
	dealer.deal_hand()

func _on_clean_up_pressed() -> void:
	dealer.clean_up_hand()

func _update_label() -> void:
	label.text = str(active_player.hand.value)
	if active_player.hand.value != active_player.hand.alt_value:
		label.text += " or "
		label.text += str(active_player.hand.alt_value)
