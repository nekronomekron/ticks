extends Resource

class_name MapSettings

enum MapType { DESSERT, FORREST }

@export var map_seed: int

@export var type: MapType = MapType.FORREST

func get_rand() -> int:
	var result = rand_from_seed(map_seed)[0]
	map_seed = result
	
	return result
