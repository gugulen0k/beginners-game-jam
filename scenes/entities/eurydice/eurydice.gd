extends Character

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D

func _physics_process(delta: float) -> void:
	DebugUI.add_property('Eurydice velocity y', velocity.y)
	
	if can_move():
		handle_movement()
		handle_jumping(delta)
		handle_rotation()
	else:
		stop()
		
	old_movement_direction = movement_direction
	move_and_slide()

func handle_rotation() -> void:
	var tween = get_tree().create_tween()
	
	if movement_direction and is_equal_approx(movement_direction, old_movement_direction):
		tween.tween_property($AnimatedSprite3D, "scale:x", movement_direction, 0.1)
		animated_sprite_3d.flip_h = movement_direction < 0
