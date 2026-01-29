extends Node

class_name StorageManager

@export var resource_card_template: PackedScene
@export var objects_container: Container

var storage: Dictionary[BaseResource, float] = {}

var capacities: Dictionary[BaseResource, Storage] = {}

func add_capacity(object: BaseObject, capacity: float):
	if !capacities.has(object.game_resource):
		capacities.set(object.game_resource, Storage.new())
		
	capacities[object.game_resource].add_capacity(object, capacity)

func add_resource(resource: BaseResource, amount: float):
	if !capacities.has(resource):
		return
	
	if !storage.has(resource):
		var new_resource_card = resource_card_template.instantiate()
		new_resource_card.resource = resource
		
		objects_container.add_child(new_resource_card)
		storage.set(resource, 0)	
	
	storage[resource] = min(capacities[resource].total_capacity, storage[resource] + amount)

func get_free_capacity(object: BaseObject) -> float:
	if !capacities.has(object.game_resource):
		return 0
		
	return capacities[object.game_resource].total_capacity - get_resource_amount(object.game_resource)

func get_resource_amount(resource: BaseResource) -> float:
	if storage.has(resource):
		return storage[resource]
	return 0

func update_ui() -> void:
	for resource_card in objects_container.get_children():
		resource_card.amount = storage[resource_card.resource]
		resource_card.capacity = capacities[resource_card.resource].total_capacity

func resources_available(resources: Dictionary[BaseResource, float]) -> bool:
	for resource in resources:
		if get_resource_amount(resource) < resources[resource]:
			return false
	return true
