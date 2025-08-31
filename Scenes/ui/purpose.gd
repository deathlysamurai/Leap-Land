extends CanvasLayer


@onready var start_button: Button = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/Button


func _ready() -> void:
	start_button.pressed.connect(start_game)

func start_game() -> void:
	GameEvents.emit_start_game()
	Data.game_started = true
	queue_free()
