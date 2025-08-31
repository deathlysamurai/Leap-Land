class_name GameManager
extends Node

const KNIGHT_SCENE = preload("uid://din6qxqag2jpy")
const SAMURAI_SCENE = preload("uid://53vqry6at7m7")
const SWORDSMAN_SCENE = preload("uid://dt8bckf6i10c6")
const CYBORG_SCENE = preload("uid://dd3nf4e4i4i3w")
const DUDE_SCENE = preload("uid://ds6bricervt4l")

@export var camera: GameCamera
@export var hud: HUD

@onready var spawn_location: Marker2D = %PlayerSpawn

var player: Player
var PLAYER_SCENE = KNIGHT_SCENE

var tween_in_time: float = 0.8
var tween_out_time: float = 0.6
var death_impact_time: float = 0.1


func _ready() -> void:
	GameEvents.player_died.connect(player_death)
	GameEvents.character_bought.connect(change_character)
	determine_character()
	spawn_player()

func change_character(character) -> void:
	determine_character()
	player.queue_free()
	respawn_player()

func determine_character() -> void:
	var character = Data.character
	if character == "knight":
		PLAYER_SCENE = KNIGHT_SCENE
	elif character == "dude":
		PLAYER_SCENE = DUDE_SCENE
	elif character == "cyborg":
		PLAYER_SCENE = CYBORG_SCENE
	elif character == "swordsman":
		PLAYER_SCENE = SWORDSMAN_SCENE
	elif character == "samurai":
		PLAYER_SCENE = SAMURAI_SCENE

func player_death() -> void:
	if player:
		await get_tree().create_timer(death_impact_time).timeout
		player.queue_free()
		spawn_player()

func _process(_delta: float) -> void:
	if player:
		if player.check_out_of_bounds():
			player.queue_free()
			respawn_player()


func spawn_player() -> void:
	player = PLAYER_SCENE.instantiate()
	player.global_position = spawn_location.global_position
	get_tree().get_first_node_in_group("entities_layer").add_child(player)
	camera.set_target(player, false)


func respawn_player() -> void:
	player = PLAYER_SCENE.instantiate()
	player.global_position = spawn_location.global_position
	get_tree().get_first_node_in_group("entities_layer").add_child(player)
	tween_in(player)
	await get_tree().create_timer(tween_in_time).timeout
	camera.set_target(player, false)


func tween_in(node: Node2D) -> void:
	var end_location := node.global_position
	var start_location := end_location + Vector2(0, -50)
	var tween := create_tween().set_parallel(true)
	tween.tween_property(node, "scale", Vector2.ONE, tween_in_time).from(Vector2(3, 3))\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(node, "position", end_location, tween_in_time).from(start_location)\
		.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(node, "rotation", 0, tween_in_time).from(2 * PI)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
