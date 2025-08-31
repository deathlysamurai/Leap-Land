extends Node


const meow_scene = preload("uid://c81a75l54ui8d")
const purpose_scene = preload("uid://dbvgsmgh16abk")

@export var inventory_manager: InventoryManager
@export var upgrade_manager: UpgradeManager
@export var next_level: PackedScene
@export var cat_scene: PackedScene


func _ready() -> void:
	$AudioStreamPlayer2D.play()
	$AudioStreamPlayer2D.position = get_tree().get_first_node_in_group("entities_layer").get_child(0).global_position
	GameEvents.treat_get.connect(treat_gotten)
	setup_data()
	if not Data.game_started:
		GameEvents.start_game.connect(meow)
		purpose()
	else:
		meow()

func setup_data() -> void:
	inventory_manager.current_inventory = Data.current_inventory
	inventory_manager.inventory_change()
	upgrade_manager.jump_count_modifier = Data.jump_count_modifier
	upgrade_manager.jump_power_modifier = Data.jump_power_modifier
	upgrade_manager.speed_modifier = Data.speed_modifier

func purpose() -> void:
	var purpose_box = purpose_scene.instantiate()
	%PlayerSpawn.add_child(purpose_box)

func meow() -> void:
	var meow_box = meow_scene.instantiate()
	%Meowser.add_child(meow_box)
	meow_box.position.x = meow_box.position.x + 15
	meow_box.position.y = meow_box.position.y - 60
	await get_tree().create_timer(2).timeout
	meow_box.queue_free()

func treat_gotten() -> void:
	if Data.current_level == 3:
		get_tree().call_deferred("change_scene_to_packed", cat_scene)
	else:
		Data.current_level += 1
		Data.current_inventory = inventory_manager.current_inventory
		Data.jump_count_modifier = upgrade_manager.jump_count_modifier
		Data.jump_power_modifier = upgrade_manager.jump_power_modifier
		Data.speed_modifier = upgrade_manager.speed_modifier
		get_tree().call_deferred("change_scene_to_packed", next_level)
