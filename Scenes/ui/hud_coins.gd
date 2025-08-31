extends HBoxContainer

@export var number_texture: NumberTextures

@onready var coin_texture: TextureRect = $CoinTexture
@onready var count_container: HBoxContainer = $CountContainer
@onready var ones_count_texture: TextureRect = %OnesCountTexture
@onready var tens_count_texture: TextureRect = %TensCountTexture
@onready var hundreds_count_texture: TextureRect = %HundredsCountTexture
@onready var thousands_count_texture: TextureRect = %ThousandsCountTexture

@onready var donut_texture: Texture2D = load("res://assets/coins/donut-ball.png")
@onready var gem_texture: Texture2D = load("res://assets/coins/gem-ball.png")
@onready var diamond_texture: Texture2D = load("res://assets/coins/diamond-ball.png")


func _ready() -> void:
	GameEvents.coin_upgrade_bought.connect(update_coin_texture)

func update_coin_texture(coin_type: String) -> void:
	if coin_type == "diamond":
		coin_texture.texture = diamond_texture
	elif coin_type == "gem":
		coin_texture.texture = gem_texture
	elif coin_type == "donut":
		coin_texture.texture = donut_texture

func update_item_display(item: InventoryObject, current_inventory: Dictionary):
	coin_texture.texture = current_inventory[item.id]["resource"].hud_texture
	var count = current_inventory[item.id]["quantity"]
	update_count(count)


## Updates the number textures. No multiplier if the count is only 1.
## Starts as a single digit, adds second digit only at 10-99. Cap of 99.
func update_count(count: int): 
	count = min(count, 99999)
	if count > 999:
		toggle_counter(true)
		@warning_ignore("integer_division")
		thousands_count_texture.texture = number_texture.numbers[count / 1000]
		@warning_ignore("integer_division")
		hundreds_count_texture.texture = number_texture.numbers[count % 1000 / 100]
		@warning_ignore("integer_division")
		tens_count_texture.texture = number_texture.numbers[count % 1000 % 100 / 10]
		ones_count_texture.texture = number_texture.numbers[count % 1000 % 100 % 10]
		thousands_count_texture.visible = true
	elif count > 99:
		toggle_counter(true)
		@warning_ignore("integer_division")
		hundreds_count_texture.texture = number_texture.numbers[count / 100]
		@warning_ignore("integer_division")
		tens_count_texture.texture = number_texture.numbers[count % 100 / 10]
		ones_count_texture.texture = number_texture.numbers[count % 100 % 10]
		hundreds_count_texture.visible = true
		thousands_count_texture.visible = false
	elif count > 9:
		toggle_counter(true)
		@warning_ignore("integer_division")
		tens_count_texture.texture = number_texture.numbers[count / 10]
		ones_count_texture.texture = number_texture.numbers[count % 10]
		tens_count_texture.visible = true
		hundreds_count_texture.visible = false
		thousands_count_texture.visible = false
	elif count >= 1:
		toggle_counter(true)
		ones_count_texture.texture = number_texture.numbers[count]
		tens_count_texture.visible = false
		hundreds_count_texture.visible = false
		thousands_count_texture.visible = false
	else:
		toggle_counter(false)


func toggle_counter(enabled: bool):
	count_container.visible = enabled
