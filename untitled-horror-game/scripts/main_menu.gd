extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var t0 = Time.get_ticks_msec()
	await get_tree().physics_frame
	print("Game loaded: ", Time.get_ticks_msec() - t0, "ms")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	var t0 = Time.get_ticks_msec()
	get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")
	print("Game start: ", Time.get_ticks_msec() - t0, "ms")


func _on_quit_pressed() -> void:
	pass # Replace with function body.
	get_tree().quit()
