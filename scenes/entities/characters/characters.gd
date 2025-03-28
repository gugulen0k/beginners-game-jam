extends Node3D

@onready var eurydice: Character = $Eurydice
@onready var orpheus: Character = $Orpheus

func _physics_process(delta: float) -> void:
	var movement_dir: float = Input.get_axis('move_left', 'move_right')
	
	orpheus.update_direction(movement_dir)
	eurydice.update_direction(movement_dir)
