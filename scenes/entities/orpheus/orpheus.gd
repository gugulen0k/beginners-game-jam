extends Character

func _physics_process(delta: float) -> void:
	DebugUI.add_property('Orpheus velocity y', velocity.y)
	
	if can_move():
		move()
		jump(delta)
	else:
		stop()
	
	move_and_slide()
