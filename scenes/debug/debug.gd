class_name GlobalDebug extends Control

var properties: Array

@onready var container: VBoxContainer = $PanelContainer/VBoxContainer

const fps_ms = 16


func add_property(id: StringName, value, time_in_frames: int = 1) -> void:
	if properties.has(id):
		if Time.get_ticks_msec() / fps_ms % time_in_frames == 0:
			var target = container.find_child(id, true, false) as Label
			target.text = id + ': ' + str(value)
	else:
		var property = Label.new()
		container.add_child(property)
		property.name = id
		property.text = id + ': ' + str(value)
		
		properties.append(id)
