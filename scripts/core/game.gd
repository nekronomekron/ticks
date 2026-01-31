extends Node

@onready var panel: Panel = $CanvasLayer/Panel

@onready var camera: Camera2D = $Camera2D

@onready var map_manager: MapManager = $MapManager



func _ready() -> void:
	panel.offset_top = 10
	panel.offset_bottom = 10
	panel.offset_left = 10
	panel.offset_right = 10
