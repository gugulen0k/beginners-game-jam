extends Node3D

@onready var marker_3d: Marker3D = $FinishZone/Marker3D

signal game_over

func _on_area_3d_body_entered(character: Character) -> void:
	if character is Orpheus:
		character.move_into_final_area_position(marker_3d)
		
	if character is Eurydice:
		character.finish_level()


func _on_game_over() -> void:
	InputSystem.can_use_eurydice = false
	InputSystem.can_use_orpheus = false
	
	$GameOver.show()
