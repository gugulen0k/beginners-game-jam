class_name Character

extends CharacterBody3D

signal jump_now

@export_category('Character parameters')
@export var jump_peak_time: float = 0.5
@export var jump_fall_time: float = 0.5
@export var jump_height: float = 2.0
@export var jump_distance: float = 4.0

var movement_speed: float
var jump_velocity: float
var movement_direction: float
var is_able_to_move: bool = true

var jump_gravity = ProjectSettings.get_setting('physics/3d/default_gravity')
var fall_gravity: float


func _ready() -> void:
	calculate_movement_parameters()
	#jump_now.connect()


func calculate_movement_parameters() -> void:
	jump_gravity = (2 * jump_height) / pow(jump_peak_time, 2)
	fall_gravity = (2 * jump_height) / pow(jump_fall_time, 2)
	jump_velocity = ((jump_gravity) * (jump_peak_time))
	movement_speed = jump_distance / (jump_peak_time + jump_fall_time)


func move() -> void:
	velocity.x = movement_direction * movement_speed

func can_move() -> bool:
	return is_able_to_move

func jump(delta: float) -> void:
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y -= jump_gravity * delta
		else:
			velocity.y -= fall_gravity * delta
	
		
	if Input.is_action_just_pressed('jump') and is_on_floor():
		velocity.y = jump_velocity


func stop() -> void:
	velocity.x = 0


func update_direction(direction: float) -> void:
	movement_direction = direction
