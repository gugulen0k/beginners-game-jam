extends Node3D


func _on_interactable_focused(interactor: Interactor) -> void:
	print('focused')

func _on_interactable_interacted(interactor: Interactor) -> void:
	print('interacted')


func _on_interactable_unfocused(interactor: Interactor) -> void:
	print('unfocused')
