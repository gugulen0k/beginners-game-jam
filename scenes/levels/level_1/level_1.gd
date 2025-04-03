extends Node3D

@export var game_over_scene: Control
@export var level_finished_scene: Control

@export var level_finish: Area3D
@export var level_finish_marker: Marker3D

@export var level_music: AudioStreamPlayer
@export var level_music_lyre: AudioStreamPlayer
@export var game_over_music: AudioStreamPlayer
@export var level_finished_music: AudioStreamPlayer
@export var cave_ambience: AudioStreamPlayer

var level_finished: bool = false

signal game_over


func _ready() -> void:
	game_over.connect(_on_game_over)
	level_music.play() # Enable level music
	level_music_lyre.volume_linear = 0
	level_music_lyre.play()
	cave_ambience.volume_linear = 0.5
	cave_ambience.play()
	
	# ----- Enable movement for both characters ----
	InputSystem.can_use_eurydice = true
	InputSystem.can_use_orpheus = true
	#-----------------------------------------------

	set_siglans_for_ui_btns()


func _physics_process(delta: float) -> void:
	#DebugUI.add_property('Characters on finish', level_finish.get_overlapping_bodies())
	
	var characters_on_finish := level_finish.get_overlapping_bodies()
	
	if characters_on_finish.size() == 2 and !level_finished:
		level_finished = true
		
		# ----- Disable movement for both characters ----
		InputSystem.can_use_eurydice = false
		InputSystem.can_use_orpheus = false
		# -----------------------------------------------
		
		level_music.stop()
		level_music_lyre.stop()
		level_finished_scene.show()
		level_finished_music.play()
		


func _on_game_over() -> void:
	# ----- Disable movement for both characters ----
	InputSystem.can_use_eurydice = false
	InputSystem.can_use_orpheus = false
	# -----------------------------------------------
	
	level_music.stop() # Stop the level music
	level_music_lyre.stop()
	
	game_over_scene.show() # Show game over UI
	game_over_music.play()
	

func _on_main_menu_pressed() -> void:
	var main_menu_scene = GlobalScenes.get_scene(GlobalScenes.SceneNames.MAIN_MENU)
	get_tree().change_scene_to_packed(main_menu_scene)


func _on_select_level_pressed() -> void:
	var select_level_scene = GlobalScenes.get_scene(GlobalScenes.SceneNames.LEVEL_SELECTION)
	get_tree().change_scene_to_packed(select_level_scene)


func _on_next_level_pressed() -> void:
	var next_scene: PackedScene = level_finished_scene.next_level_btn.next_level_scene
	get_tree().change_scene_to_packed(next_scene)


func _on_try_again_pressed() -> void:
	get_tree().reload_current_scene()
	
	# ----- Enable movement for both characters ----
	InputSystem.can_use_eurydice = true
	InputSystem.can_use_orpheus = true
	#-----------------------------------------------


func set_siglans_for_ui_btns() -> void:
	# ----- Get buttons from UI scenes & assign signals -----
	# GameOver UI buttons
	var go_try_again_btn = game_over_scene.try_again_btn
	go_try_again_btn.pressed.connect(_on_try_again_pressed)
	
	# LevelFinished UI buttons
	var lf_next_level_btn = level_finished_scene.next_level_btn
	lf_next_level_btn.pressed.connect(_on_next_level_pressed)
	# --------------------------------------------------------------


func _on_finish_zone_body_entered(character: Character) -> void:
	if character is Orpheus:
		level_music_lyre.volume_linear = 1
		character.move_into_final_area_position(level_finish_marker)
