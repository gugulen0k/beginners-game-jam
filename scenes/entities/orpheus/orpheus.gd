class_name Orpheus

extends Character

@onready var orpheus_character: Node3D = $OrpheusCharacter
@onready var raycasts_origin: Marker3D = $RaycastsOrigin


func _physics_process(delta: float) -> void:
	DebugUI.add_property('Orpheus velocity y', velocity.y)
	DebugUI.add_property('Orpheus movement direction', movement_direction)
	DebugUI.add_property('Orpheus anim state', orpheus_character.get_anim_state())
	
	if can_move():
		handle_movement()
		handle_jumping(delta)
		handle_rotation(delta)
		
		if is_moving():
			orpheus_character.set_anim_state('walk')
		else:
			orpheus_character.set_anim_state('idle')
	else:
		stop()
	
	detect_eurydice()
	
	move_and_slide()


func line(pos1: Vector3, pos2: Vector3, color = Color.RED, persist_ms = 1):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()

	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	return await final_cleanup(mesh_instance, persist_ms)

## 1 -> Lasts ONLY for current physics frame
## >1 -> Lasts X time duration.
## <1 -> Stays indefinitely
func final_cleanup(mesh_instance: MeshInstance3D, persist_ms: float):
	get_tree().get_root().add_child(mesh_instance)
	if persist_ms == 1:
		await get_tree().physics_frame
		mesh_instance.queue_free()
	elif persist_ms > 0:
		await get_tree().create_timer(persist_ms).timeout
		mesh_instance.queue_free()
	else:
		return mesh_instance

enum CollisionLayers {
	ORPHEUS,
	EURYDICE,
	CHARACTER
}

func detect_eurydice() -> void:
	var space_state = get_world_3d().direct_space_state
	
	print()
	var query = PhysicsRayQueryParameters3D.create(raycasts_origin.position, Vector3(100, 0, 0), CollisionLayers.EURYDICE)
	line(to_global(raycasts_origin.position), to_global(Vector3(0, 0, -100)))
	var result := space_state.intersect_ray(query)
	
	print(result)
