extends Node

class_name MapManager

@export var map_themes: Dictionary[MapSettings.MapType, MapTheme] = {}

@onready var terrain_layer: TileMapLayer = $TerrainLayer
@onready var obstacles_layer: TileMapLayer = $ObstaclesLayer
