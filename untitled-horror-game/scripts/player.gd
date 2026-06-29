extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var color_rect: ColorRect = $ColorRect
@onready var hitbox: Area2D = $hitbox

const SPEED = 100.0
var direction: Vector2
var vision_circle_radius = 0.1



func _physics_process(delta: float) -> void:
	var movement_delta = SPEED*delta*100
	color_rect.set_instance_shader_parameter("radius", vision_circle_radius)
	direction = Input.get_vector("ui_left", "ui_right","ui_up","ui_down")
	if direction:
		velocity = direction * movement_delta
	else:
		velocity = Vector2.ZERO
	animation()
	move_and_slide()

func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("ui_accept"):
		color_rect.visible = false
	else:
		color_rect.visible = true

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


func player():
	pass



func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("cat"):
		vision_circle_radius += 0.05
		body.queue_free()
	if body.has_method("big_scary"):
		print("Jumpscare")


func _on_hitbox_body_exited(_body: Node2D) -> void:
	pass # Replace with function body.
