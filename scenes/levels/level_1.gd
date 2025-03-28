extends Node3D

@onready var marker_3d: Marker3D = $FinishZone/Marker3D

var SETTLE_ANIMATION_SPEED: float = 3
var orpheus: Orpheus

func _physics_process(delta: float) -> void:
	if orpheus:
		orpheus.global_position = orpheus.global_position.lerp(
			marker_3d.global_position, 
			SETTLE_ANIMATION_SPEED * delta
		)
		
		await get_tree().create_timer(SETTLE_ANIMATION_SPEED / 2).timeout
		
		orpheus.transform.basis = Basis.looking_at(Vector3.LEFT)
		orpheus.orpheus_character.set_anim_state('idle')


func _on_area_3d_body_entered(character: Character) -> void:
	character.is_able_to_move = false
	
	if character is Orpheus:
		orpheus = character
