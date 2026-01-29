extends Node

class_name GameManager

@export var time_manager: TimeManager
@export var storage_manager: StorageManager
@export var map_generator: MapGenerator

@export var start_object_templates: Array[PackedScene] = []
@export var available_object_templates: Array[PackedScene] = []

@export var objects_container: Container

var _prepared_objects: Array[BaseObject] = []

func _ready() -> void:
	time_manager.on_tick.connect(_on_tick)
	
	for start_object_template in start_object_templates:
		var start_object = start_object_template.instantiate()
		start_object.game_manager = self
		
		objects_container.add_child(start_object)
		
	for available_object_template in available_object_templates:
		var available_object = available_object_template.instantiate()
		available_object.game_manager = self
		
		_prepared_objects.append(available_object)
		
	var map_settings: MapSettings = MapSettings.new()
	# map_settings.type = MapSettings.MapType.DESSERT
	map_generator.generate(map_settings)

func _on_tick() -> void:
	var modifiers: Dictionary[BaseResource, float] = {}
	
	for season_modifier in time_manager.current_season.modifiers:
		if modifiers.has(season_modifier):
			modifiers[season_modifier] *= time_manager.current_season.modifiers[season_modifier]
		else:
			modifiers.set(season_modifier, time_manager.current_season.modifiers[season_modifier])
	
	#
	# Update all child objects
	#
	for game_object in objects_container.get_children():
		game_object.on_tick(modifiers)
		
	#
	# Add new objects
	#		
	for available_game_object in _prepared_objects:
		if storage_manager.resources_available(available_game_object.requirements):
			_prepared_objects.erase(available_game_object)
			objects_container.add_child(available_game_object)
	
	storage_manager.update_ui()

func get_free_capacity(object: BaseObject) -> float:
	return storage_manager.get_free_capacity(object)
	
func add_capacity(object: BaseObject, capacity: float) -> void:
	storage_manager.add_capacity(object, capacity)

func add_resource(resource: BaseResource, amount: float):
	storage_manager.add_resource(resource, amount)

func buy_object(costs: Dictionary[BaseResource, float]) -> bool:
	if !storage_manager.resources_available(costs):
		return false
		
	for resource in costs:
		storage_manager.add_resource(resource, -costs[resource])
		
	return true
