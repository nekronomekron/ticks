extends Node2D

class_name GameManager

@export var map_manager: MapManager

var is_dragging: bool = false
var drag_offset: Vector2

func _ready() -> void:
	init(randi())

func init(map_seed: int) -> void:
	var map_settings: MapSettings = MapSettings.new()
	map_settings.map_seed = map_seed
	map_settings.type = (map_settings.get_rand() % MapSettings.MapType.size()) as MapSettings.MapType
	
	map_manager.init(map_settings)
	map_manager.center_camera(get_viewport().get_camera_2d())
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			is_dragging = true
			drag_offset = get_viewport().get_mouse_position()
		elif event.button_index == MOUSE_BUTTON_RIGHT and !event.pressed:
			is_dragging = false
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			map_manager.zoom_camera_at_point(get_viewport().get_camera_2d(), 0.1, get_global_mouse_position())
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			map_manager.zoom_camera_at_point(get_viewport().get_camera_2d(), -0.1, get_global_mouse_position())
	
func _process(_delta: float) -> void:
	if is_dragging:
		var drag:Vector2 = drag_offset - get_viewport().get_mouse_position()
		
		if drag.length() == 0:
			return
		
		drag_offset = get_viewport().get_mouse_position()
		map_manager.move_camera(get_viewport().get_camera_2d(), drag)
