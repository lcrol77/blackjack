extends GameState

@onready var player_label: Label = %PlayerLabel
@onready var deal_button: Button = %DealButton
@onready var dealer_label: Label = %DealerLabel

func enter()-> void:
	deal_button.show()
	player_label.hide()
	dealer_label.hide()
	
func exit() -> void:
	deal_button.hide()
	player_label.show()
	dealer_label.show()
