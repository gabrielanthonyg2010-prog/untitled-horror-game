extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@export var cat_frame: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = randf_range(0.5,1.5)
	$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	sprite_2d.frame = cat_frame

func cat():
	pass


func _on_timer_timeout() -> void:
	$Meow2Tmjbru.play()
	$Meow2Tmjbru.pitch_scale = randf_range(0.75,1.5)
	$Timer.wait_time = randf_range(2,4)
	$Timer.start()
