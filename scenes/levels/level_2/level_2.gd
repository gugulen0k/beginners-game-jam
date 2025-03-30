extends Node3D

@export var game_over_scene: Control
@export var level_finished_scene: Control

@export var level_finish: Area3D
@export var level_finish_marker: Marker3D

@export var level_music: AudioStreamPlayer

signal game_over


func _ready() -> void:
	#level_music.play() # Enable level music
	
	# ----- Enable movement for both characters ----
	InputSystem.can_use_eurydice = true
	InputSystem.can_use_orpheus = true
	#-----------------------------------------------

	set_siglans_for_ui_btns()


func _physics_process(delta: float) -> void:
	DebugUI.add_property('Characters on finish', level_finish.get_overlapping_bodies())
	
	var characters_on_finish := level_finish.get_overlapping_bodies()
	
	if characters_on_finish.size() == 2:
		# ----- Disable movement for both characters ----
		InputSystem.can_use_eurydice = false
		InputSystem.can_use_orpheus = false
		# -----------------------------------------------
		
		level_finished_scene.show()


func _on_area_3d_body_entered(character: Character) -> void:
	if character is Orpheus:
		character.move_into_final_area_position(level_finish_marker)


func _on_game_over() -> void:
	# ----- Disable movement for both characters ----
	InputSystem.can_use_eurydice = false
	InputSystem.can_use_orpheus = false
	# -----------------------------------------------
	
	game_over_scene.show() # Show game over UI
	
	#level_music.stop() # Stop the level music

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
	var go_main_menu_btn = game_over_scene.main_menu_btn
	var go_try_again_btn = game_over_scene.try_again_btn
	var go_select_level_btn = game_over_scene.select_level_btn
	
	go_try_again_btn.pressed.connect(_on_try_again_pressed)
	go_main_menu_btn.pressed.connect(_on_main_menu_pressed)
	go_select_level_btn.pressed.connect(_on_select_level_pressed)
	
	# LevelFinished UI buttons
	var lf_main_menu_btn = level_finished_scene.main_menu_btn
	var lf_next_level_btn = level_finished_scene.next_level_btn
	
	lf_main_menu_btn.pressed.connect(_on_main_menu_pressed)
	lf_next_level_btn.presseed.connect(_on_next_level_pressed)
	# --------------------------------------------------------------
