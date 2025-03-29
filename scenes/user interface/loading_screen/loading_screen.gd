extends Control

func _process(delta: float) -> void:
	
	var loader_status = ResourceLoader.load_threaded_get_status(SceneLoading.scene_path_to_load)
	DebugUI.add_property("Load Status", loader_status)
	
	if loader_status == ResourceLoader.THREAD_LOAD_LOADED:
		var level := ResourceLoader.load_threaded_get(SceneLoading.scene_path_to_load)
		get_tree().change_scene_to_packed(level)
