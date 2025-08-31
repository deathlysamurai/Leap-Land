extends Area2D


func _on_body_entered(_body: Node2D) -> void:
	GameEvents.emit_player_died()
