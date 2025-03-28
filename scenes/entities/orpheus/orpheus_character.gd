extends Node3D

@onready var anim_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get('parameters/playback')


func set_anim_state(name: String) -> void:
	anim_state_machine.travel(name)


func get_anim_state() -> String:
	return anim_state_machine.get_current_node()
