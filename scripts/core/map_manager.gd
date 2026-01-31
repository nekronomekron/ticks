extends Node

class_name MapManager

@export var map_themes: Dictionary[MapSettings.MapType, MapTheme] = {}

@export var min_chunk_size: Vector2i = Vector2i(4, 4)
@export var max_chunk_size: Vector2i = Vector2i(12, 12)

@onready var terrain_layer: TileMapLayer = $TerrainLayer
@onready var obstacles_layer: TileMapLayer = $ObstaclesLayer

var _map_settings: MapSettings
var _map_theme: MapTheme

var _used_rect: Rect2i = Rect2i(0, 0, 0, 0)

func init(map_settings: MapSettings) -> void:
	_map_settings = map_settings
	_map_settings.type = 0
	_map_theme = map_themes[_map_settings.type]
	
	terrain_layer.tile_set = _map_theme.tileset
	obstacles_layer.tile_set = _map_theme.decoration_tileset
	
	var visible_rect = get_viewport().get_visible_rect()
	# terrain_layer.translate(visible_rect.size / 2)
	
	set_terrain_for_rect(world_rect_to_map(visible_rect, 1, 1, 1, 1), 0)	
	generate_chunk()
	
func center_camera(camera: Camera2D):
	move_camera(camera, get_map_center(), false)

func move_camera_absolute(camera: Camera2D, position: Vector2, position_smoothing: bool = true):
	var map_used_rect = get_used_rect()
				
	position.x = min(map_used_rect.end.x, max(map_used_rect.position.x, position.x))
	position.y = min(map_used_rect.end.y, max(map_used_rect.position.y, position.y))
		
	if camera.global_position == position:
		return
		
	var position_smoothing_enabled:bool = camera.position_smoothing_enabled
	camera.position_smoothing_enabled = position_smoothing
			
	camera.global_position = position
	fill_visible_area(camera)
	
	camera.position_smoothing_enabled = position_smoothing_enabled
	
func zoom_camera_at_point(camera: Camera2D, zoom_delta: float, point: Vector2):
	var target_zoom: Vector2 = Vector2(clamp(camera.zoom.x + zoom_delta, 1.0, 2.0), clamp(camera.zoom.y + zoom_delta, 1.0, 2.0))
	var offset = (camera.global_position - point) * (target_zoom - camera.zoom)
	
	camera.zoom = target_zoom
	camera.global_position -= offset
	
	fill_visible_area(camera)
	
func move_camera(camera: Camera2D, drag: Vector2, position_smoothing: bool = true):
	move_camera_absolute(camera, camera.global_position + drag, position_smoothing)
	
func get_used_rect(margin_left: int = 0, margin_top: int = 0, margin_right: int = 0, margin_bottom: int = 0) -> Rect2:
	var top_left: Vector2 = terrain_layer.to_global(terrain_layer.map_to_local(Vector2(_used_rect.position))) - Vector2(margin_left, margin_top)
	var bottom_right: Vector2 = terrain_layer.to_global(terrain_layer.map_to_local(Vector2(_used_rect.end))) + Vector2(margin_right, margin_bottom)
		
	return Rect2(top_left, bottom_right - top_left)
	
func get_map_center() -> Vector2:
	var used_rect = get_used_rect()
	return used_rect.position + (used_rect.size / 2)
	
func generate_chunk() -> void:
	var chunk_width = max(min_chunk_size.x, (_map_settings.get_rand() % max_chunk_size.x) + 1)
	var chunk_height = max(min_chunk_size.y, (_map_settings.get_rand() % max_chunk_size.y) + 1)
	
	var rect = Rect2i(0, 0, chunk_width, chunk_height)
	_used_rect = _used_rect.merge(rect)
			
	set_terrain_for_rect(rect, 1, true)

func fill_visible_area(camera: Camera2D) -> void:
	var viewport_rect = camera.get_viewport_rect()
	var camera_position = camera.global_position
	
	var rect = world_rect_to_map(Rect2i(camera_position - (viewport_rect.size / 2), viewport_rect.size), 1, 1, 1, 1)
	
	set_terrain_for_rect(rect, 0)	

func set_terrain_for_rect(rect: Rect2i, terrain: int, override: bool = false) -> void:
	var cells: Array[Vector2i] = []
	
	for x in range(rect.position.x, rect.end.x + 1):
		for y in range(rect.position.y, rect.end.y + 1):
			if override || terrain_layer.get_cell_tile_data(Vector2i(x, y)) == null:
				cells.append(Vector2i(x, y))
	
	terrain_layer.set_cells_terrain_connect(cells, 0, terrain)

func world_rect_to_map(rect: Rect2i, margin_left: int = 0, margin_top: int = 0, margin_right: int = 0, margin_bottom: int = 0) -> Rect2i:
	var half_size = rect.size / 2.0
	var center = Vector2(rect.position) + half_size
	var top_left = center - half_size
	var bottom_right = center + half_size
	
	var top_left_tile: Vector2i = terrain_layer.local_to_map(terrain_layer.to_local(top_left)) - Vector2i(margin_left, margin_top)
	var bottom_right_tile: Vector2i = terrain_layer.local_to_map(terrain_layer.to_local(bottom_right)) + Vector2i(margin_right, margin_bottom)
	
	return Rect2i(
		top_left_tile,
		bottom_right_tile - top_left_tile
	)
