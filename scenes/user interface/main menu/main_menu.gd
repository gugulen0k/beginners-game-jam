extends Control

var packed_level_selection = preload("res://scenes/user interface/level_selection/level_selection.tscn")

@onready var play_button : Button = %PlayButton

func _ready() -> void:
	play_button.pressed.connect(transition_to_level_selection)
	
func transition_to_level_selection() -> void:
	get_tree().change_scene_to_packed(packed_level_selection)
