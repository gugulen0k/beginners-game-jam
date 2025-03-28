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
var is_able_to_move: bool = true

var jump_gravity = ProjectSettings.get_setting('physics/3d/default_gravity')
var fall_gravity: float


func _ready() -> void:
	calculate_movement_parameters()
	transform.basis = Basis.looking_at(Vector3.RIGHT)


func calculate_movement_parameters() -> void:
	jump_gravity = (2 * jump_height) / pow(jump_peak_time, 2)
	fall_gravity = (2 * jump_height) / pow(jump_fall_time, 2)
	jump_velocity = ((jump_gravity) * (jump_peak_time))
	movement_speed = jump_distance / (jump_peak_time + jump_fall_time)


func handle_movement() -> void:
	velocity.x = movement_direction * movement_speed


func can_move() -> bool:
	return is_able_to_move


func is_moving() -> bool:
	if movement_direction: return true
	
	return false

func update_direction(direction: float) -> void:
	movement_direction = direction


func stop() -> void:
	velocity.x = 0


func handle_jumping(delta: float) -> void:
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y -= jump_gravity * delta
		else:
			velocity.y -= fall_gravity * delta
	
		
	if Input.is_action_just_pressed('jump') and is_on_floor():
		velocity.y = jump_velocity
		

func handle_rotation(delta: float) -> void:
	if movement_direction:
		var direction_vector := Vector3(movement_direction, 0, 0)
		
		transform.basis = Basis.looking_at(direction_vector)
		
		#var current_rotation: Quaternion = Quaternion(transform.basis).normalized()
		#var direction_vector := Vector3(movement_direction, 0, 0)
		#var looking_direction: Quaternion = Quaternion(Basis.looking_at(direction_vector)).normalized()
		#var target_rotation = current_rotation.slerp(looking_direction, rotation_speed * delta)
		#transform.basis = Basis(target_rotation)
