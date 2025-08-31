extends Area2D


var in_shop: bool = false
var input_shop: bool = false
var shop_open: bool = false


func _ready() -> void:
	GameEvents.close_shop.connect(shop_closed)

func _process(_delta: float) -> void:
	input_shop = Input.is_action_pressed("shop")
	if in_shop and input_shop and not shop_open:
		shop_open = true
		GameEvents.emit_open_shop()

func shop_closed() -> void:
	shop_open = false

func _on_area_entered(_area: Area2D) -> void:
	in_shop = true

func _on_area_exited(_area: Area2D) -> void:
	in_shop = false
