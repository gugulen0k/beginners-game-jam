extends Control

@export var loading_screen_packed_scene : PackedScene

@export var buttons : Array[LevelButton]

func _ready() -> void:
	for button in buttons:
		button.pressed.connect(_on_load_level.bind(button.level_scene_path))

func _on_load_level(level_scene_path: String) -> void:
	ResourceLoader.load_threaded_request(level_scene_path)
	SceneLoading.scene_path_to_load = level_scene_path
	get_tree().change_scene_to_packed(loading_screen_packed_scene)
