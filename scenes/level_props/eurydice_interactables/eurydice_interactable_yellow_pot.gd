extends Node3D

@onready var pot_sprite: AnimatedSprite3D = $AnimatedSprite3D


func _on_interactable_focused(interactor: Interactor) -> void:
	pass

func _on_interactable_interacted(interactor: Interactor) -> void:
	pot_sprite.play('interact')
	LevelsInfo.level_3['is_gate_open'] = true


func _on_interactable_unfocused(interactor: Interactor) -> void:
	pass
