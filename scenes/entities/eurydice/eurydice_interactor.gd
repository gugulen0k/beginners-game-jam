extends Interactor

@export var player: CharacterBody3D

var cached_closest: Interactable


func _ready() -> void:
	controller = player


func _physics_process(delta: float) -> void:
	var new_closest: Interactable = get_closest_interactable()
	
	if new_closest == cached_closest: return
	
	if is_instance_valid(cached_closest): unfocus(cached_closest)
	if new_closest: focus(new_closest)
	
	cached_closest = new_closest


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("interact"): return
	if not cached_closest: return
	
	interact(cached_closest)
