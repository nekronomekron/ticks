extends Node

class_name MapGenerator

@export var map_themes: Dictionary[MapSettings.MapType, MapTheme] = {}

@onready var tile_map_layer: TileMapLayer = $TileMapLayer
@onready var decoration_tile_map_layer: TileMapLayer = $TileMapLayer2

func generate(map_settings: MapSettings) -> void:
	var map_theme: MapTheme = map_themes[map_settings.type]
	
	tile_map_layer.tile_set = map_theme.tileset
	decoration_tile_map_layer.tile_set = map_theme.decoration_tileset
	
	var target_size = get_viewport().get_visible_rect().size
	
	var _rows = ceili(target_size.x / tile_map_layer.tile_set.tile_size.x / tile_map_layer.scale.x) + 2
	var _columns = ceili(target_size.y / tile_map_layer.tile_set.tile_size.y / tile_map_layer.scale.y) + 2
	
	var _land_rows = _rows - 2
	var _land_columns = _columns - 2
	
	render_terrain_cells(-2, -2, _rows + 2, _columns + 2, 0, 0)
	render_terrain_cells(1, 1, _land_rows, _land_columns, 0, 1)
	
	for index in range(randi_range(2, 12)):
		decoration_tile_map_layer.set_cell(Vector2i(randi_range(2, _land_rows - 3), randi_range(2, _land_columns - 3)), 0, map_theme.decoration_tiles[randi_range(0, map_theme.decoration_tiles.size() - 1)])
	
	var _land_width = _land_rows * tile_map_layer.tile_set.tile_size.x * tile_map_layer.scale.x
	var _land_height = _land_columns * tile_map_layer.tile_set.tile_size.y * tile_map_layer.scale.y
	
	var offset_x = (-(tile_map_layer.tile_set.tile_size.x * tile_map_layer.scale.x) + (target_size.x - _land_width)) / 2
	var offset_y = (-(tile_map_layer.tile_set.tile_size.y * tile_map_layer.scale.y) + (target_size.y - _land_height)) / 2
	
	tile_map_layer.translate(Vector2(offset_x, offset_y))
	decoration_tile_map_layer.translate(Vector2(offset_x, offset_y))

func render_terrain_cells(x_start: int, y_start: int, x_end: int, y_end: int, terrain_set: int, terrain: int) -> void:
	var cells: Array[Vector2i] = []
	
	for x in range(x_start, x_end):
		for y in range(y_start, y_end):
			cells.append(Vector2i(x, y))
	
	tile_map_layer.set_cells_terrain_connect(cells, terrain_set, terrain)
