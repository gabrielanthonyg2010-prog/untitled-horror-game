extends Node

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var scene_timer: Timer = $scene_timer

var progress = []
var sceneName
var scene_load_status = 0
var load_in_once = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.frame = 0
	sceneName = "res://scenes/world.tscn"
	ResourceLoader.load_threaded_request(sceneName)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName,progress)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		if not load_in_once:
			load_in_once = true


func _on_timer_timeout() -> void:
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var newScene = ResourceLoader.load_threaded_get(sceneName)
		await SceneTransitionScene.change_scene("")
		get_tree().change_scene_to_packed(newScene)


func _on_scene_timer_timeout() -> void:
	if sprite_2d.frame != 4:
		await SceneTransitionScene.change_scene("")
		sprite_2d.frame += 1
		scene_timer.start()
		return
	$Timer.start()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("SKIP"):
		sprite_2d.frame = 4
		while not scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
			await get_tree().physics_frame
			_on_timer_timeout()
