extends Node

var progress = []
var sceneName
var scene_load_status = 0
var load_in_once = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sceneName = "res://scenes/world.tscn"
	ResourceLoader.load_threaded_request(sceneName)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName,progress)
	$MarginContainer/VBoxContainer/ProgressBar.value = progress[0]*100
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		if not load_in_once:
			load_in_once = true
			$Timer.start()


func _on_timer_timeout() -> void:
	var newScene = ResourceLoader.load_threaded_get(sceneName)
	get_tree().change_scene_to_packed(newScene)
