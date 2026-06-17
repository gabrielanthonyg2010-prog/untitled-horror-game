extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 1000.0
var direction: Vector2

func _physics_process(delta: float) -> void:
	direction = Input.get_vector("ui_left", "ui_right","ui_up","ui_down")
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO
	animation()
	move_and_slide()

func animation():
	var dir = Input.get_axis("ui_left","ui_right")
	if direction:
		if dir:
			if dir > 0:
				anim.flip_h = false
			else:
				anim.flip_h = true
		anim.play("walk")
	else:
		anim.play("idle")
