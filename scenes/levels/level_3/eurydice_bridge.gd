extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func play_open_eurydice_bridge_anim() -> void:
	animation_player.play("GateopenEury")
