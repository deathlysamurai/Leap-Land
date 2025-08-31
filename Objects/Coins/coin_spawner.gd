extends Node2D


@export var coin_scene : PackedScene

var coin_removed: bool = false
var player_respawned: bool = false

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#GameEvents.player_died.connect(respawn_coin)

func _process(_delta: float) -> void:
	if self.get_child_count() == 0:
		spawn_coin()

#func respawn_coin() -> void:
	#player_respawned = true
	#coin_removed = false
	#if self.get_child_count() == 0:
		#spawn_coin()

func spawn_coin() -> void:
	var coin = coin_scene.instantiate()
	self.call_deferred("add_child", coin)
	coin_removed = true
	player_respawned = false


#func _on_coin_tree_exited() -> void:
	#spawn_coin()
