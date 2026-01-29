extends Control

@onready var panel: Panel = $Panel

func _ready() -> void:
	panel.offset_top = 10
	panel.offset_bottom = 10
	panel.offset_left = 10
	panel.offset_right = 10
