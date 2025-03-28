extends Character

func _physics_process(delta: float) -> void:
	DebugUI.add_property('Eurydice velocity y', velocity.y)
	
	if can_move():
		handle_movement()
		handle_jumping(delta)
		handle_rotation(delta)
	else:
		stop()
		
	move_and_slide()
