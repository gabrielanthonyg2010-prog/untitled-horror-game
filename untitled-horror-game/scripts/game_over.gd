extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Bbfbba97115046Cf918117533Da4c60f.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	SceneTransitionScene.change_scene("res://scenes/world.tscn")
