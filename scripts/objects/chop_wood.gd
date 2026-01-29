extends BaseObject

func _ready() -> void:
	game_manager.add_capacity(self, 20)
	super._ready()

func on_chop_wood(modifiers: Dictionary[BaseResource, float]):
	var modifier:float = 1.0
	if modifiers.has(game_resource):
		modifier = modifiers[game_resource]
		
	game_manager.add_resource(game_resource, modifier)
