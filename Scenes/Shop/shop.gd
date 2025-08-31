extends Node2D


var shop_open: bool = false
var input_shop_close: bool = false


func _ready() -> void:
	GameEvents.open_shop.connect(shop_opening)

func _process(_delta: float) -> void:
	input_shop_close = Input.is_action_pressed("shop_close")
	if shop_open and input_shop_close:
		close_shop()

func shop_opening() -> void:
	$ShopScreen.visible = true
	shop_open = true

func close_shop() -> void:
	GameEvents.emit_close_shop()
	shop_open = false
	$ShopScreen.visible = false
