class_name Orpheus

extends Character

@export var level: Node3D

@onready var orpheus_character: Node3D = $Orpheus
@onready var raycasts_origin: Marker3D = $RaycastMarkers/RaycastsOrigin
@onready var gaze_cone_start: Marker3D = $RaycastMarkers/GazeConeStart
@onready var gaze_cone_end: Marker3D = $RaycastMarkers/GazeConeEnd
@onready var raycast_markers: Node3D = $RaycastMarkers

const RAY_LENGTH: int = 50
const RAYS_COUNT: int = 3
const SETTLE_ANIMATION_SPEED: float = 1

var is_eurydice_detected: bool = false
var can_interrupt: Array[State] = [State.IDLE, State.WALKING]  # States that can be interrupted


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	#DebugUI.add_property('Orpheus movement dir', movement_direction)
	#DebugUI.add_property('Orpheus velocity X', velocity.x)
	#DebugUI.add_property('Orpheus is in transition', is_in_transition)
	#DebugUI.add_property('Current animation', orpheus_character.get_anim_state())
	#DebugUI.add_property("Orpheus current state", State.keys()[current_state])
	#DebugUI.add_property("Orpheus previous state", State.keys()[previous_state])
	#DebugUI.add_property("On floor", is_on_floor())
	
	if can_perform_actions():
		handle_movement()
		handle_jumping(delta)
		handle_rotation()
	else:
		stop()
		current_state = State.IDLE
		
		if not is_eurydice_detected:
			detect_eurydice()
	
	if previous_state != current_state:
		play_state_animation()
	
	move_and_slide()

func play_state_animation():
	match current_state:
		State.IDLE:
			orpheus_character.set_anim_state("idle")
		State.WALKING:
			orpheus_character.set_anim_state("walk")
		State.JUMPING:
			orpheus_character.set_anim_state("jump")
		State.FALLING:
			orpheus_character.set_anim_state("fall")
		State.LYRE:
			orpheus_character.set_anim_state("lyre")
		State.LYRE_TAKEOUT:
			orpheus_character.set_anim_state("lyre_takeout")


func line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE, persist_ms = 1):
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

# collision layers start from 1 for some reason so we have to define the values for this enum
enum CollisionLayers {
	ORPHEUS = 1,
	EURYDICE = 2,
	CHARACTER = 4,
	RAYCAST_HITTABLE = 8
}

func detect_eurydice() -> void:
	var space_state := get_world_3d().direct_space_state
	# ray start position is in global space
	var ray_start_position := to_global(raycasts_origin.position)
	var ray_cone_start_direction := (gaze_cone_start.global_position - ray_start_position).normalized()
	var ray_cone_end_direction := (gaze_cone_end.global_position - ray_start_position).normalized()
	
	for i in range(RAYS_COUNT):
		var t := float(i) / (RAYS_COUNT - 1) # Normalized value from 0.0 to 1.0
		var interpolated_ray_direction := ray_cone_start_direction.lerp(ray_cone_end_direction, t)
		
		# ray end position is the ray start position + the movement vector from that position
		var ray_end_position := ray_start_position + interpolated_ray_direction * RAY_LENGTH
		
		var query := PhysicsRayQueryParameters3D.create(ray_start_position, ray_end_position, CollisionLayers.RAYCAST_HITTABLE)
		query.hit_from_inside = true
		
		var result := space_state.intersect_ray(query)
		# for seeing the ray
		if (result):
			if (result.collider.name == "Eurydice"):
				#line(ray_start_position, ray_end_position, Color.RED)
				is_eurydice_detected = true
				level.game_over.emit()
			#else:
				#line(ray_start_position, ray_end_position, Color.ORANGE)
		#else:
			#line(ray_start_position, ray_end_position, Color.GREEN)


func move_into_final_area_position(marker_3d: Marker3D) -> void:
	InputSystem.can_use_orpheus = false
	InputSystem.can_use_eurydice = false
	
	var tween = get_tree().create_tween()
	# will change the global position to the marker 3d global position over the SETTLE_ANIMATION_SPEED in seconds
	tween.tween_property(self, "global_position", marker_3d.global_position + (global_position - $Feet.global_position), SETTLE_ANIMATION_SPEED)
	
	# Use the tween's finished callback for the actions after the movement
	tween.finished.connect(on_move_into_final_area_finished)


func on_move_into_final_area_finished() -> void:
	transform.basis = transform.basis.looking_at(Vector3.LEFT)
	
	InputSystem.can_use_eurydice = true
	InputSystem.can_use_orpheus = false


func handle_rotation() -> void:
	if movement_direction:
		transform.basis = Basis.looking_at(Vector3(movement_direction, 0, 0))
