extends Node2D

@onready var name_label: Label = $NinePatchRect/NameLabel
@onready var amount_label: Label = $NinePatchRect/AmountLabel

@export var resource: BaseResource

@export var amount: float:
	get:
		return amount
	set(value):
		amount = value
		_update_label()

@export var capacity: float:
	get:
		return capacity
	set(value):
		capacity = value
		_update_label()

func _update_label() -> void:
	if amount_label != null:
		amount_label.text = "%.2f / %.2f max." % [amount, capacity]

func _ready() -> void:
	name_label.text = resource.identifier
	amount_label.text = "0"
