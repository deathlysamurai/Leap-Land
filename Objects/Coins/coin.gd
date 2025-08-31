extends Node2D
class_name Coin

@export var item_resource: InventoryObject
@export var count: int = 1

@onready var sprite: Sprite2D = $Sprite2D
@onready var donut_texture: Texture2D = load("res://assets/coins/donut-ball.png")
@onready var gem_texture: Texture2D = load("res://assets/coins/gem-ball.png")
@onready var diamond_texture: Texture2D = load("res://assets/coins/diamond-ball.png")


func _ready() -> void:
	$PickupArea2D.area_entered.connect(on_area_entered, CONNECT_ONE_SHOT)
	update_coin_textures(Data.coin_type)
	GameEvents.coin_upgrade_bought.connect(update_coin_textures)

func update_coin_textures(coin_type: String) -> void:
	if coin_type == "diamond":
		item_resource.world_texture = diamond_texture
		item_resource.hud_texture = diamond_texture
		sprite.texture = diamond_texture
		count = 10
	elif coin_type == "gem":
		item_resource.world_texture = gem_texture
		item_resource.hud_texture = gem_texture
		sprite.texture = gem_texture
		count = 5
	elif coin_type == "donut":
		item_resource.world_texture = donut_texture
		item_resource.hud_texture = donut_texture
		sprite.texture = donut_texture
		count = 2

func tween_collect(percent: float, start_position: Vector2):
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return
	
	global_position = start_position.lerp(player.global_position, percent)
	var direction_from_start = player.global_position - start_position
	
	var target_rotation = direction_from_start.angle() + deg_to_rad(-90)
	rotation = lerp_angle(rotation, target_rotation, (1 - exp(-2 * get_process_delta_time())))


func collect():
	GameEvents.emit_player_inventory_add_to(item_resource, count)
	queue_free()


func on_area_entered(_other_area: Area2D):
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_method(tween_collect.bind(global_position), 0.0, 1.0, 0.5)\
	.set_ease(Tween.EASE_IN)\
	.set_trans(Tween.TRANS_BACK)
	tween.tween_property(sprite, "scale", Vector2(2, 2), .25).set_delay(.1)
	tween.tween_property(sprite, "scale", Vector2.ZERO, .15).set_delay(.35)
	tween.chain()
	tween.tween_callback(collect)
