extends Node

@onready var panel_container: PanelContainer = $PanelContainer
@export var difficulty_groupd: ButtonGroup
var buttons: Array = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var t0 = Time.get_ticks_msec()
	await get_tree().physics_frame
	print("Game loaded: ", Time.get_ticks_msec() - t0, "ms")
	for button in difficulty_groupd.get_buttons():
		button.pressed.connect(_on_button_pressed.bind(button))
		buttons.append(button)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	var t0 = Time.get_ticks_msec()
	SceneTransitionScene.change_scene("res://scenes/loading_screen.tscn")
	print("Game start: ", Time.get_ticks_msec() - t0, "ms")

func _on_difficulties_pressed() -> void:
	if not panel_container.visible:
		panel_container.visible = true
	else:
		panel_container.visible = false

func _on_quit_pressed() -> void:
	pass # Replace with function body.
	get_tree().quit()

func _on_button_pressed(button: Button):
	match button.name:
		"NORMAL":
			Global.difficulty = Global.Difficulties.Normal
		"HARD":
			Global.difficulty = Global.Difficulties.Hard
	print(Global.difficulty)
