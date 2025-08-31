extends CharacterBody2D
class_name Player


@export var BASE_SPEED = 100.0
@export var BASE_SPRINT_FACTOR := 2
@export var BASE_JUMP_VELOCITY = -300.0
@export var JUMP_CANCEL_FACTOR := .75
@export var max_jump_count := 1
@export var is_cat: bool = false

@onready var player_animation : AnimatedSprite2D = $PlayerSprite
@onready var state_machine: StateMachine = $StateMachine

var upgrade_manager: UpgradeManager
var default_gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var falling_gravity: float = 1800.0
var current_jump_count := 0
var move_direction_x := 0.0

var input_left := false
var input_right := false
var input_sprint := false
var input_jump := false
var input_jump_just_pressed := false
var game_paused


func _ready() -> void:	
	state_machine.init(self, player_animation)
	if not is_cat:
		upgrade_manager = get_tree().get_first_node_in_group("upgrade_manager")
		if not Data.game_started:
			game_paused = true
			GameEvents.start_game.connect(start_game)
		else:
			game_paused = false

func start_game() -> void:
	game_paused = false

func _physics_process(_delta: float) -> void:
	if not game_paused:
		get_input_states()
		flip_direction()
		move_and_slide()

func get_input_states() -> void:
	input_left = Input.is_action_pressed("move_left")
	input_right = Input.is_action_pressed("move_right")
	input_sprint = Input.is_action_pressed("sprint")
	input_jump = Input.is_action_pressed("jump")
	input_jump_just_pressed = Input.is_action_just_pressed("jump")
	
func flip_direction() -> void:
	# Change visuals left/right orientation
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		player_animation.scale = Vector2(move_sign, 1)

func handle_landing() -> void:
	if is_on_floor():
		state_machine.change_state("idle")

func handle_falling() -> void:
	# See if player is falling, such as getting bumped or walked off a ledge.
	if !is_on_floor():
		state_machine.change_state("fall")

func apply_gravity(delta: float, gravity: float = default_gravity) -> void:
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		current_jump_count = 0

func handle_horizontal_movement(delta: float) -> void:
	move_direction_x = Input.get_axis("move_left", "move_right")
	if move_direction_x!= 0:
		if upgrade_manager:
			velocity.x = move_direction_x * BASE_SPEED * upgrade_manager.speed_modifier
		else: 
			velocity.x = move_direction_x * BASE_SPEED
		if input_sprint:
			velocity.x *= BASE_SPRINT_FACTOR
	else:
		velocity.x = lerpf(velocity.x, 0.0, (1 - exp(-10 * delta)))

func handle_jump() -> void:
	var jumps = max_jump_count
	if upgrade_manager:
		jumps = max_jump_count * upgrade_manager.jump_count_modifier
	if input_jump_just_pressed and current_jump_count < jumps:
		state_machine.change_state("jump")
		current_jump_count += 1

func check_out_of_bounds() -> bool:
	if global_position.y > 3_000: return true
	else: return false
