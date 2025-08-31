extends CanvasLayer
class_name HUD

@export var inventory_manager: InventoryManager
@export var hud_coin_scene: PackedScene

@onready var coin_container: VBoxContainer = %CoinContainer


func _ready() -> void:
	GameEvents.player_inventory_changed.connect(on_inventory_changed)
	update_inventory(inventory_manager.get_current_inventory())


func _clear_container(container: Node):
	var container_children = container.get_children()
	for i in container_children.size():
			container_children[i].queue_free()


func update_inventory(current_inventory: Dictionary):
	_clear_container(coin_container)
	
	for item in current_inventory:
		var hud_coin_instance = hud_coin_scene.instantiate()
		coin_container.add_child(hud_coin_instance)
		hud_coin_instance.update_item_display(current_inventory[item]["resource"], current_inventory)


func on_inventory_changed(current_inventory):
	update_inventory(current_inventory)
