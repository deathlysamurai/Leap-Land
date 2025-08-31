extends CanvasLayer


@onready var current_speed_label: Label = %CurrentSpeedLabel
@onready var jump_power_label: Label = %CurrentJumpPowerLabel
@onready var jump_count_label: Label = %CurrentJumpCountLabel

@onready var speed_button: Button = %SpeedMoneyButton
@onready var jump_power_button: Button = %JumpPowerMoneyButton
@onready var jump_count_button: Button = %JumpCountMoneyButton
@onready var donut_button: Button = %DonutMoneyButton
@onready var gem_button: Button = %GemMoneyButton
@onready var diamond_button: Button = %DiamondMoneyButton
@onready var samurai_button: Button = %SamuraiMoneyButton
@onready var swordsman_button: Button = %SwordsmanMoneyButton
@onready var cyborg_button: Button = %CyborgMoneyButton
@onready var dude_button: Button = %DudeMoneyButton

var speed_increase_factor: float = 0.2
var jump_power_increase_factor: float = 0.1

var starting_speed_price: int = 5
var starting_jump_power_price: int = 5
var starting_jump_count_price: int = 40


func _ready() -> void:
	speed_button.pressed.connect(upgrade_speed)
	jump_power_button.pressed.connect(upgrade_jump_power)
	jump_count_button.pressed.connect(upgrade_jump_count)
	donut_button.pressed.connect(upgrade_coins.bind("donut", 100))
	gem_button.pressed.connect(upgrade_coins.bind("gem", 250))
	diamond_button.pressed.connect(upgrade_coins.bind("diamond", 1000))
	samurai_button.pressed.connect(buying_character.bind("samurai", 75))
	swordsman_button.pressed.connect(buying_character.bind("swordsman", 150))
	cyborg_button.pressed.connect(buying_character.bind("cyborg", 300))
	dude_button.pressed.connect(buying_character.bind("dude", 1000))
	GameEvents.upgrade_bought_success.connect(bought_successfully)
	GameEvents.coin_upgrade_bought.connect(coin_bought_successfully)
	GameEvents.character_bought.connect(character_bought_successfully)
	set_starting_texts()

func upgrade_coins(coin_type: String, price: int) -> void:
	GameEvents.emit_upgrade_coins(coin_type, price)

func coin_bought_successfully(coin_type: String) -> void:
	$AudioStreamPlayer2D.play()
	if coin_type == "diamond":
		diamond_button.disabled = true
	elif coin_type == "gem":
		gem_button.disabled = true
	elif coin_type == "donut":
		donut_button.disabled = true

func upgrade_speed() -> void:
	var price = int(speed_button.text.split("$")[1])
	var current_speed = float(current_speed_label.text)
	var new_speed = current_speed + speed_increase_factor
	GameEvents.emit_upgrade_bought("speed", price, new_speed)

func upgrade_jump_power() -> void:
	var price = int(jump_power_button.text.split("$")[1])
	var current_power = float(jump_power_label.text)
	var new_power = current_power + jump_power_increase_factor
	GameEvents.emit_upgrade_bought("jump_power", price, new_power)

func upgrade_jump_count() -> void:
	var price = int(jump_count_button.text.split("$")[1])
	var current_jump_count = int(jump_count_label.text)
	var new_jump_count = current_jump_count + 1
	GameEvents.emit_upgrade_bought("jump_count", price, new_jump_count)

func bought_successfully(upgrade: String, price: int, value: float) -> void:
	$AudioStreamPlayer2D.play()
	if upgrade == "speed":
		current_speed_label.text = str(value)
		speed_button.text = "$" + str(price + 1)
		if Data.current_speed_upgrades >= Data.max_speed_upgrades:
			speed_button.disabled = true
	if upgrade == "jump_power":
		jump_power_label.text = str(value)
		jump_power_button.text = "$" + str(price + 2)
		if Data.current_jump_power_upgrades >= Data.max_jump_power_upgrades:
			jump_power_button.disabled = true
	if upgrade == "jump_count":
		jump_count_label.text = str(value)
		jump_count_button.text = "$" + str(price * 2)
		if Data.current_jump_count_upgrades >= Data.max_jump_count_upgrades:
			jump_count_button.disabled = true

func buying_character(character: String, price: int) -> void:
	GameEvents.emit_buying_character(character, price)

func character_bought_successfully(character: String) -> void:
	$AudioStreamPlayer2D.play()
	speed_button.disabled = false
	jump_power_button.disabled = false
	jump_count_button.disabled = false
	if character == "dude":
		dude_button.disabled = true
	elif character == "cyborg":
		cyborg_button.disabled = true
	elif character == "swordsman":
		swordsman_button.disabled = true
	elif character == "samurai":
		samurai_button.disabled = true

func set_starting_texts() -> void:
	current_speed_label.text = str(Data.speed_modifier)
	jump_power_label.text = str(Data.jump_power_modifier)
	jump_count_label.text = str(Data.jump_count_modifier)
	speed_button.text = "$" + str(int(Data.speed_modifier / speed_increase_factor))
	var jump_power_num_bought = ((Data.jump_power_modifier / jump_power_increase_factor) - 10)
	jump_power_button.text = "$" + str(int(starting_jump_power_price + (jump_power_num_bought * 2)))
	jump_count_button.text = "$" + str(int(Data.jump_count_modifier * starting_jump_count_price))
	var coin_type = Data.coin_type
	if coin_type == "diamond":
		diamond_button.disabled = true
		gem_button.disabled = true
		donut_button.disabled = true
	elif coin_type == "gem":
		gem_button.disabled = true
		donut_button.disabled = true
	elif coin_type == "donut":
		donut_button.disabled = true
	var character = Data.character
	if character == "dude":
		dude_button.disabled = true
		cyborg_button.disabled = true
		swordsman_button.disabled = true
		samurai_button.disabled = true
	elif character == "cyborg":
		cyborg_button.disabled = true
		swordsman_button.disabled = true
		samurai_button.disabled = true
	elif character == "swordsman":
		swordsman_button.disabled = true
		samurai_button.disabled = true
	elif character == "samurai":
		samurai_button.disabled = true
