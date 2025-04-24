@tool
class_name Card
extends Sprite2D

@export var stats: CardStats : set = set_stats

func _ready() -> void:
	pass

func set_stats(value: CardStats) -> void:
	stats = value
	if value == null:
		return
	if not is_node_ready():
		await ready
	region_rect.position = Vector2(stats.skin_coordinates) * 65
