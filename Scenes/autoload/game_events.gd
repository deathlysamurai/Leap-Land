extends Node
## Provides [signals] used for updating UI and managers

signal player_inventory_changed(inventory: Dictionary)
signal player_inventory_add_to(item: InventoryObject, count: int)
signal player_died
signal open_shop
signal close_shop
signal upgrade_bought(upgrade: String, price: int, value: float)
signal upgrade_bought_success(upgrade: String, price: int, value: float)
signal treat_get
signal upgrade_coins(coin_type: String, price: int)
signal coin_upgrade_bought(coin_type: String)
signal start_game
signal buying_character(character: String, price: int)
signal character_bought(character: String)


func emit_player_inventory_changed(current_inventory: Dictionary):
	player_inventory_changed.emit(current_inventory)

func emit_player_inventory_add_to(item: InventoryObject, count: int):
	player_inventory_add_to.emit(item, count)	

func emit_player_died():
	player_died.emit()

func emit_open_shop():
	open_shop.emit()

func emit_close_shop():
	close_shop.emit()

func emit_upgrade_bought(upgrade: String, price: int, value: float):
	upgrade_bought.emit(upgrade, price, value)

func emit_upgrade_bought_success(upgrade: String, price: int, value: float):
	upgrade_bought_success.emit(upgrade, price, value)

func emit_treat_get():
	treat_get.emit()

func emit_upgrade_coins(coin_type: String, price: int):
	upgrade_coins.emit(coin_type, price)

func emit_coin_upgrade_bought(coin_type: String):
	coin_upgrade_bought.emit(coin_type)

func emit_start_game():
	start_game.emit()

func emit_buying_character(character: String, price: int):
	buying_character.emit(character, price)

func emit_character_bought(character: String):
	character_bought.emit(character)
