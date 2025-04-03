extends Node3D

@onready var eurydice: Character = $Eurydice
@onready var orpheus: Character = $Orpheus


func _physics_process(delta: float) -> void:
	#DebugUI.add_property('Orpheus InputSystem', InputSystem.can_use_orpheus)
		
	var movement_dir: float = Input.get_axis('move_left', 'move_right')
	
	orpheus.is_able_to_perform_actions = InputSystem.can_use_orpheus
	eurydice.is_able_to_perform_actions = InputSystem.can_use_eurydice
	
	orpheus.update_direction(movement_dir)
	orpheus.jumping(Input.is_action_just_pressed('jump'))
	
	eurydice.update_direction(movement_dir)
	eurydice.jumping(Input.is_action_just_pressed('jump'))
