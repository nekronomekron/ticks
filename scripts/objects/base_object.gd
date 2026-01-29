extends NinePatchRect

class_name BaseObject

signal on_action_triggered(modifiers: Dictionary[BaseResource, float])
signal on_ticks_filled(modifiers: Dictionary[BaseResource, float])

@onready var resource_name_label: Label = $Label
@onready var action_button: Button = $Button
@onready var buy_button: Button = $BuyButton
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var is_active_switch: CheckButton = $CheckButton

@export var game_manager: GameManager
@export var game_resource: BaseResource
@export var ticks_needed: int = 4

@export var requirements: Dictionary[BaseResource, float] = {}
@export var costs: Dictionary[BaseResource, float] = {}

@export
var has_action_button: bool = true:
	get:
		return has_action_button
	set(value):
		has_action_button = value
		if action_button != null:
			action_button.visible = has_action_button
			
@export
var has_progress_bar: bool = true:
	get:
		return has_progress_bar
	set(value):
		has_progress_bar = value
		if progress_bar != null:
			progress_bar.visible = has_progress_bar
			
@export
var can_buy: bool = true:
	get:
		return can_buy
	set(value):
		can_buy = value
		if buy_button != null:
			buy_button.visible = can_buy
			
var action_triggered: bool:
	get:
		return action_triggered
	set(value):
		action_triggered = value
		if action_button != null:
			action_button.disabled != action_triggered

var current_ticks: int = 0

var object_count: int = 0

func _ready() -> void:
	if can_buy:
		resource_name_label.text = "%s (%s)" % [game_resource.identifier, object_count]
	else:
		resource_name_label.text = game_resource.identifier
		
	action_button.visible = has_action_button
	progress_bar.visible = has_progress_bar
	buy_button.visible = can_buy

func _on_action_button_pressed() -> void:
	action_triggered = true
	
func _on_buy_button_pressed() -> void:
	if game_manager.buy_object(costs):
		object_count += 1
		resource_name_label.text = "%s (%s)" % [game_resource.identifier, object_count]
		
		_on_update_costs()

func _on_update_costs() -> void:
	pass
	
func on_tick(modifiers: Dictionary[BaseResource, float]) -> void:
	if action_triggered:
		on_action_triggered.emit(modifiers)
		action_triggered = false
	
	if !is_active_switch.button_pressed || object_count <= 0 || game_manager.get_free_capacity(self) == 0:
		return

	current_ticks += 1
	if current_ticks >= ticks_needed:
		current_ticks = 0
		on_ticks_filled.emit(modifiers)
	
	progress_bar.value = float(current_ticks) / ticks_needed * 100.0
