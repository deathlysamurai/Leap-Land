extends Sprite2D


@export var cat_level: bool = false


func _on_area_2d_area_entered(_area: Area2D) -> void:
	$AudioStreamPlayer2D.play()
	GameEvents.emit_treat_get()
	if cat_level: queue_free()
