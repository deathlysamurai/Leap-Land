extends Node
class_name InventoryManager

## The inventory is stored as a [param Dictionary] of [param Dictionary]'s.
## The first key is the [param InventoryObject.id]. the nested keys are
## "resource" for the [param InventoryObject] itself, and "quantity" for the
## amount of that item in the inventory.
var current_inventory: Dictionary = {}

@onready var donut_texture: Texture2D = load("res://assets/coins/donut-ball.png")
@onready var gem_texture: Texture2D = load("res://assets/coins/gem-ball.png")
@onready var diamond_texture: Texture2D = load("res://assets/coins/diamond-ball.png")


func _ready() -> void:
	GameEvents.player_inventory_add_to.connect(on_inventory_added_to)
	GameEvents.coin_upgrade_bought.connect(update_coin_textures)

func update_coin_textures(coin_type: String) -> void:
	if not current_inventory.has("coin_gold"): return 
	if coin_type == "diamond":
		current_inventory["coin_gold"]["resource"].world_texture = diamond_texture
		current_inventory["coin_gold"]["resource"].hud_texture = diamond_texture
	elif coin_type == "gem":
		current_inventory["coin_gold"]["resource"].world_texture = gem_texture
		current_inventory["coin_gold"]["resource"].hud_texture = gem_texture
	elif coin_type == "donut":
		current_inventory["coin_gold"]["resource"].world_texture = donut_texture
		current_inventory["coin_gold"]["resource"].hud_texture = donut_texture

func add_to_inventory(item: InventoryObject, count: int):
	if not current_inventory.has(item.id):
		current_inventory[item.id] = {
			"resource": item,
			"quantity": count
			}
	else:
		current_inventory[item.id]["quantity"] += count
	$AudioStreamPlayer2D.play()
	inventory_change()


func remove_from_inventory(item: InventoryObject, count: int):
	if current_inventory.has(item.id):
		current_inventory[item.id]["quantity"] -= count
		if current_inventory[item.id]["quantity"] <= 0:
			current_inventory.erase(item.id)
	inventory_change()


func inventory_change():
	GameEvents.emit_player_inventory_changed(get_current_inventory())


## Gets a duplicate reference to the current inventory. Ideally the actual inventory is only manipulated within this class.
func get_current_inventory():
	var current_inventory_dupe = current_inventory.duplicate()
	return current_inventory_dupe


func on_inventory_added_to(item: InventoryObject, count: int):
	if count > 0:
		add_to_inventory(item, count)
	else:
		remove_from_inventory(item, count)
