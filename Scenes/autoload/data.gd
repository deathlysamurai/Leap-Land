extends Node

var current_level: int = 1
var current_inventory: Dictionary = {}
var speed_modifier: float = 1.0
var jump_power_modifier: float = 1.0
var jump_count_modifier: int = 1
var coin_type: String = "gold"
var game_started: bool = false
var character: String = "knight"
var max_speed_upgrades = 5
var max_jump_power_upgrades = 5
var max_jump_count_upgrades = 1
var current_speed_upgrades = 0
var current_jump_power_upgrades = 0
var current_jump_count_upgrades = 0
