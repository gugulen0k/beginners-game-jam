extends Control

@onready var play_button : Button = %PlayButton

func _ready() -> void:
	play_button.pressed.connect(transition_to_level_selection)
	
func transition_to_level_selection() -> void:
	var level_selection_scene = GlobalScenes.get_scene(GlobalScenes.SceneNames.LEVEL_SELECTION)
	get_tree().change_scene_to_packed(level_selection_scene)
