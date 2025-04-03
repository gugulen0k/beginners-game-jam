extends Control

@export var play_btn: Button
@export var first_level_scene: PackedScene
@onready var main_theme: AudioStreamPlayer = $MainTheme


func _ready() -> void:
	play_btn.pressed.connect(_on_transition_to_first_level)
	main_theme.play()
	
func _on_transition_to_first_level() -> void:
	get_tree().change_scene_to_packed(first_level_scene)
