class_name Character

extends CharacterBody3D

@export_category('Character parameters')

@export_category('Jumping')
@export var jump_peak_time: float = 0.5
@export var jump_fall_time: float = 0.5
@export var jump_height: float = 2.0
@export var jump_distance: float = 4.0

@export_category('Rotation')
@export var rotation_speed: float = 8.0

var movement_speed: float
var jump_velocity: float
var movement_direction: float
var old_movement_direction: float
var is_able_to_perform_actions: bool
var is_jumping: bool = false

# State Machine related variables
enum State { IDLE, WALKING, JUMPING, FALLING, LANDING }
var current_state: State = State.IDLE
var previous_state: State = State.IDLE
var was_on_floor: bool = true
var just_landed: bool = false  # New flag for landing detection
var is_in_landing_animation: bool = false  # Track if we're in landing animation

var jump_gravity = ProjectSettings.get_setting('physics/3d/default_gravity')
var fall_gravity: float


func _ready() -> void:
	calculate_movement_parameters()


func _physics_process(delta: float) -> void:
	previous_state = current_state
	update_state()
	was_on_floor = is_on_floor()


func calculate_movement_parameters() -> void:
	jump_gravity = (2 * jump_height) / pow(jump_peak_time, 2)
	fall_gravity = (2 * jump_height) / pow(jump_fall_time, 2)
	jump_velocity = ((jump_gravity) * (jump_peak_time))
	movement_speed = jump_distance / (jump_peak_time + jump_fall_time)


func handle_movement() -> void:
	velocity.x = movement_direction * movement_speed


func can_perform_actions() -> bool:
	return is_able_to_perform_actions


func is_moving() -> bool:
	return abs(movement_direction) > 0.1  # Add small threshold to prevent flickering


func update_direction(direction: float) -> void:
	movement_direction = direction


func jumping(value: bool) -> void:
	is_jumping = value


func stop() -> void:
	velocity.x = 0


func update_state() -> void:
	if is_in_landing_animation:
		return  # Don't change state during landing animation
	
	if not is_on_floor():
		if velocity.y > 0:
			current_state = State.JUMPING
		else:
			current_state = State.FALLING
	elif not was_on_floor and is_on_floor():
		current_state = State.LANDING
	elif is_moving():
		current_state = State.WALKING
	else:
		current_state = State.IDLE

func handle_jumping(delta: float) -> void:
	

	if not is_on_floor():
		if velocity.y > 0:
			velocity.y -= jump_gravity * delta
		else:
			velocity.y -= fall_gravity * delta
		
	if is_jumping and is_on_floor():
		velocity.y = jump_velocity
