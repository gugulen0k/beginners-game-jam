extends Node

enum SceneNames { MAIN_MENU, LOADING_SCREEN, LEVEL_SELECTION, LEVEL_FINISHED }

@export var scenes: Dictionary[SceneNames, PackedScene]

func get_scene(scene_name: SceneNames) -> PackedScene:
	return scenes[scene_name]
