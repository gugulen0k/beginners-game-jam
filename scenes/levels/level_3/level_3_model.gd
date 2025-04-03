extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func play_open_orpheus_gate_anim() -> void:
	animation_player.play("GateopenOrph")
	
