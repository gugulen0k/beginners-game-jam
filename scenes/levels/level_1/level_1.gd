extends Node3D

@export var game_over_scene: Control
@export var level_finish: Area3D
@export var level_finish_marker: Marker3D

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

signal game_over


func _ready() -> void:
	audio_player.play() # Enable level music
	
	# ----- Enable movement for both characters ----
	InputSystem.can_use_eurydice = true
	InputSystem.can_use_orpheus = true
	#-----------------------------------------------
	
	# ----- Get buttons from game_over scene & assign signals -----
	var main_menu_btn = game_over_scene.main_menu_btn
	var retry_btn = game_over_scene.try_again_btn
	var select_level_btn = game_over_scene.select_level_btn
	
	retry_btn.pressed.connect(_on_retry_level_pressed)
	main_menu_btn.pressed.connect(_on_main_menu_pressed)
	select_level_btn.pressed.connect(_on_select_level_pressed)
	# --------------------------------------------------------------


func _physics_process(delta: float) -> void:
	DebugUI.add_property('Characters on finish', level_finish.get_overlapping_bodies())
	
	var characters_on_finish := level_finish.get_overlapping_bodies()
	
	if characters_on_finish.size() == 2:
		var level_finish_scene = GlobalScenes.get_scene(GlobalScenes.SceneNames.LEVEL_FINISHED)
		get_tree().change_scene_to_packed(level_finish_scene)

func _on_area_3d_body_entered(character: Character) -> void:
	if character is Orpheus:
		character.move_into_final_area_position(level_finish_marker)


func _on_game_over() -> void:
	# ----- Disable movement for both characters ----
	InputSystem.can_use_eurydice = false
	InputSystem.can_use_orpheus = false
	# -----------------------------------------------
	
	$GameOver.show() # Show game over UI
	
	audio_player.stop() # Stop the level music

func _on_main_menu_pressed() -> void:
	var main_menu_scene = GlobalScenes.get_scene(GlobalScenes.SceneNames.MAIN_MENU)
	get_tree().change_scene_to_packed(main_menu_scene)


func _on_select_level_pressed() -> void:
	var select_level_scene = GlobalScenes.get_scene(GlobalScenes.SceneNames.LEVEL_SELECTION)
	get_tree().change_scene_to_packed(select_level_scene)


func _on_retry_level_pressed() -> void:
	get_tree().reload_current_scene()
	
	# ----- Enable movement for both characters ----
	InputSystem.can_use_eurydice = true
	InputSystem.can_use_orpheus = true
	#-----------------------------------------------
