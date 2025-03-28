extends Node3D


func _on_area_3d_body_entered(body: Character) -> void:
	body.is_able_to_move = false
