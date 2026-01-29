extends BaseObject

func _on_on_ticks_filled(modifiers: Dictionary[BaseResource, float]) -> void:
	var modifier:float = 1.0
	if modifiers.has(game_resource):
		modifier = modifiers[game_resource]
	
	game_manager.add_resource(game_resource, object_count * modifier)

func _on_update_costs() -> void:
	pass
