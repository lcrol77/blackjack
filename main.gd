extends Control


func _on_deal_pressed() -> void:
	Signals.deal_new_hand.emit()


func _on_clean_up_pressed() -> void:
	Signals.clean_up_hand.emit()
