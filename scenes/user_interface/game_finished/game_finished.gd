extends Control

@onready var main_theme: AudioStreamPlayer = $MainTheme


func _ready() -> void:
	main_theme.play()
