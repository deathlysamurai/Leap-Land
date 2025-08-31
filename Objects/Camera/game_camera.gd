class_name GameCamera
extends Camera2D

const NOISE_GROWTH: float = 750.0
const MOTION_DAMPING: float = 10

@export var noise_texture: FastNoiseLite
@export var shake_strength: float

var noise_offset_x: float
var noise_offset_y: float
@export var target: Node2D


func _ready() -> void:
	if target:
		global_position = target.global_position


func _process(delta: float) -> void:
	follow_target(delta)
	
	noise_offset_x += NOISE_GROWTH * delta
	noise_offset_y += NOISE_GROWTH * delta
	
	var offset_sample_x := noise_texture.get_noise_2d(noise_offset_x, 0)
	var offset_sample_y := noise_texture.get_noise_2d(0, noise_offset_y)
	
	offset = Vector2(offset_sample_x, offset_sample_y) * shake_strength + Vector2(0.0, -50.0)


func set_target(new_target: Node2D, smooth: bool = true) -> void:
	target = new_target
	if smooth: return
	
	global_position = target.global_position


func follow_target(delta: float) -> void:
	if is_instance_valid(target):
		global_position = lerp(global_position, target.global_position, 1 - exp(-MOTION_DAMPING * delta))
