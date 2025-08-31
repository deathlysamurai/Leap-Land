extends PlayerState


func enter() -> void:
	super()


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	player.handle_falling()
	player.handle_jump()
	player.handle_horizontal_movement(_delta)
	if player.move_direction_x != 0:
		if player.input_sprint:
			transition.emit(self, "sprint")
		else:
			transition.emit(self, "walk")
