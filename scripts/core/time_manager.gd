extends Node

class_name TimeManager

@export_range(0, 2000)
var tick_time: float = 200

@export
var ticks_per_day: int = 4

@export
var days_per_season: int = 25

@export
var seasons: Array[Season] = []

@export
var is_paused: bool = false

var current_season: Season:
	get:
		return seasons[season_index]

signal on_tick
signal on_change_day(old: int, new: int)
signal on_change_season(old: Season, new: Season)
signal on_change_year(old: int, new: int)

var last_tick: float = 0

var tick: int = 0:
	get:
		return tick
	set(value):
		if value != tick:
			on_tick.emit()
			tick = value

var day: int = 0:
	get:
		return day
	set(value):
		if day != value:
			on_change_day.emit(day, value)
			day = value	

var year: int = 0:
	get:
		return year
	set(value):
		if year != value:
			on_change_year.emit(year, value)
			year = value

var season_index: int = 0:
	get:
		return season_index
	set(value):
		if season_index != value:
			on_change_season.emit(seasons[season_index], seasons[value])
			season_index = value

func _process(delta: float) -> void:
	if is_paused:
		return
		
	last_tick += delta * 1000
	
	if last_tick >= tick_time:
		last_tick = 0
		add_ticks(1)

func add_ticks(ticks_to_add: int) -> void:
	var updated_tick = tick + ticks_to_add
	
	var updated_day = day
	var updated_year = year
	var updated_season_index = season_index
	
	if updated_tick >= ticks_per_day:
		updated_tick = 0		
		updated_day += 1

		if updated_day >= seasons.size() * days_per_season:
			updated_year += 1
			updated_day = 0
			updated_season_index = 0
			
		elif updated_day % days_per_season == 0:
			updated_season_index += 1
	
	tick = updated_tick
	day = updated_day
	year = updated_year
	season_index = updated_season_index
