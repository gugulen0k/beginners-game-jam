extends Node3D

@onready var marker_3d: Marker3D = $FinishZone/Marker3D

var SETTLE_ANIMATION_SPEED: float = 3
var orpheus: Orpheus

func _on_area_3d_body_entered(character: Character) -> void:
	if character is Orpheus:
		orpheus = character
		orpheus.move_into_final_area_position(marker_3d)
