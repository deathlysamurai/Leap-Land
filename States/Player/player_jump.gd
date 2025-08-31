extends PlayerState


@export var jump_sound: AudioStreamPlayer2D


func enter() -> void:
	super()
	var jump_speed = player.BASE_JUMP_VELOCITY
	if player.upgrade_manager:
		jump_speed = player.BASE_JUMP_VELOCITY * player.upgrade_manager.jump_power_modifier		
	player.velocity.y = jump_speed
	jump_sound.play()


func exit() -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	falling_transition()
	player.apply_gravity(_delta)
	player.handle_horizontal_movement(_delta)
	player.handle_jump()


func falling_transition() -> void:
	if player.velocity.y >= 0:
		transition.emit(self, "fall")
	if not player.input_jump:
		player.velocity.y *= player.JUMP_CANCEL_FACTOR
		transition.emit(self, "fall")
