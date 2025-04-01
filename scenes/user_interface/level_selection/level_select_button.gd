class_name LevelButton
extends Button

@export var level_scene : Resource
var level_scene_path : String

func _ready() -> void:
	level_scene_path = level_scene.resource_path
