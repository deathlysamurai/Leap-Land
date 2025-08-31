extends Node
class_name UpgradeManager


@export var inventory_manager: InventoryManager
@export var coin_object: InventoryObject

@onready var donut_texture: Texture2D = load("res://assets/coins/donut-ball.png")
@onready var gem_texture: Texture2D = load("res://assets/coins/gem-ball.png")
@onready var diamond_texture: Texture2D = load("res://assets/coins/diamond-ball.png")

var speed_modifier: float = 1.0
var jump_power_modifier: float = 1.0
var jump_count_modifier: int = 1


func _ready() -> void:
	GameEvents.upgrade_bought.connect(buying_upgrade)
	GameEvents.upgrade_coins.connect(upgrading_coins)
	GameEvents.buying_character.connect(buy_character)

func buying_upgrade(upgrade: String, price: int, value: float) -> void:
	var current_inventory = inventory_manager.get_current_inventory()
	if current_inventory.has("coin_gold"):
		var coin_count = current_inventory.get("coin_gold")["quantity"]
		if coin_count >= price:
			inventory_manager.remove_from_inventory(coin_object, price)
			if upgrade == "speed": 
				speed_modifier = value
				Data.current_speed_upgrades += 1
			if upgrade == "jump_power": 
				jump_power_modifier = value
				Data.current_jump_power_upgrades += 1
			if upgrade == "jump_count": 
				jump_count_modifier = int(value)
				Data.current_jump_count_upgrades += 1
			GameEvents.emit_upgrade_bought_success(upgrade, price, value)

func upgrading_coins(coin_type: String, price: int) -> void:
	var current_inventory = inventory_manager.get_current_inventory()
	if current_inventory.has("coin_gold"):
		var coin_count = current_inventory.get("coin_gold")["quantity"]
		if coin_count >= price:
			inventory_manager.remove_from_inventory(coin_object, price)
			GameEvents.emit_coin_upgrade_bought(coin_type)
			update_coin_textures(coin_type)
			Data.coin_type = coin_type

func update_coin_textures(coin_type: String) -> void:
	if coin_type == "diamond":
		coin_object.world_texture = diamond_texture
		coin_object.hud_texture = diamond_texture
	elif coin_type == "gem":
		coin_object.world_texture = gem_texture
		coin_object.hud_texture = gem_texture
	elif coin_type == "donut":
		coin_object.world_texture = donut_texture
		coin_object.hud_texture = donut_texture

func buy_character(character: String, price: int) -> void:
	var current_inventory = inventory_manager.get_current_inventory()
	if current_inventory.has("coin_gold"):
		var coin_count = current_inventory.get("coin_gold")["quantity"]
		if coin_count >= price:
			inventory_manager.remove_from_inventory(coin_object, price)
			Data.character = character
			GameEvents.emit_character_bought(character)
			Data.current_jump_count_upgrades = 0
			Data.current_jump_power_upgrades = 0
			Data.current_speed_upgrades = 0
			Data.max_jump_count_upgrades += 1
			Data.max_jump_power_upgrades += 1
			Data.max_speed_upgrades += 1
