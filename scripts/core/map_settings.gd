extends Resource

class_name MapSettings

enum MapType { DESSERT, FORREST }

@export var seed: int

@export var type: MapType = MapType.FORREST

func get_rand() -> int:
	var result = rand_from_seed(seed)[0]
	seed = result
	
	return result
