class_name Eurydice

extends Character

@onready var animated_sprite: AnimatedSprite3D = $AnimatedSprite3D
var landing_animation_playing: bool = false


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	#DebugUI.add_property('Eurydice velocity Y', velocity.y)
	#DebugUI.add_property('Eurydice movement direction', movement_direction)
	#DebugUI.add_property('Eurydice animation', animated_sprite.animation)
	#DebugUI.add_property("State", State.keys()[current_state])
	#DebugUI.add_property("On floor", is_on_floor())
	#
	if can_perform_actions():
		handle_movement()
		handle_jumping(delta)
		handle_rotation()
	else:
		stop()
		current_state = State.IDLE
	
	if previous_state != current_state:
		play_state_animation()

	move_and_slide()
	
func play_state_animation():
	match current_state:
		State.IDLE:
			animated_sprite.play("idle")
		State.WALKING:
			animated_sprite.play("walking")
		State.JUMPING:
			animated_sprite.play("jumping")
		State.FALLING:
			animated_sprite.play("falling")
		State.LANDING:
			is_in_landing_animation = true
			animated_sprite.play("landing")
			await animated_sprite.animation_finished
			is_in_landing_animation = false
			
			# Update state after landing animation
			update_state()
			play_state_animation()  # Play new state's animation


func handle_rotation() -> void:
	if is_moving():
		var base_scale = .75
		
		var tween = get_tree().create_tween()
		tween.tween_property(animated_sprite, 'scale:x', base_scale * (-1 if movement_direction < 0 else 1), 0.1)
