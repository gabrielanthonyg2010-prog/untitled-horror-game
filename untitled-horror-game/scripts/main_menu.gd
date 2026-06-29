extends Node

@onready var panel_container: PanelContainer = $PanelContainer
@export var difficulty_groupd: ButtonGroup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var t0 = Time.get_ticks_msec()
	await get_tree().physics_frame
	print("Game loaded: ", Time.get_ticks_msec() - t0, "ms")
	for i in difficulty_groupd.get_buttons():
		i.connect("pressed",button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	var t0 = Time.get_ticks_msec()
	get_tree().change_scene_to_file("res://scenes/loading_screen.tscn")
	print("Game start: ", Time.get_ticks_msec() - t0, "ms")

func _on_difficulties_pressed() -> void:
	if not panel_container.visible:
		panel_container.visible = true
	else:
		panel_container.visible = false

func _on_quit_pressed() -> void:
	pass # Replace with function body.
	get_tree().quit()

func button_pressed():
	match difficulty_groupd.get_pressed_button():
		"NORMAL":
			Global.difficulty = Global.Difficulties.Normal
		"HARD":
			Global.difficulty = Global.Difficulties.Hard
	print(Global.difficulty)
