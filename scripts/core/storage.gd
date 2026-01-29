class_name Storage
	
var capacities: Dictionary[BaseObject, float] = {}

var total_capacity: float:
	get:
		var result = 0
		for object in capacities:
			result += capacities[object]
		
		return result

func add_capacity(object: BaseObject, capacity: float) -> void:
	if !capacities.has(object):
		capacities.set(object, capacity)
