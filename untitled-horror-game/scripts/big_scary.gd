extends CharacterBody2D

@onready var navigation_timer: Timer = $navigation_timer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 75.0
enum states{
	idle,
	chase,
	roam
}
var movement_delta: float
var target = null
var next_position: Vector2
var state = states.idle
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if animated_sprite_2d.frame == 11:
		if not(abs(position - next_position).length() < 5):
			movement_delta = SPEED*delta*100
			move_and_slide()
		else:
			if state == states.roam:
				_on_roam_timer_timeout()
		next_position = navigation_agent_2d.get_next_path_position()
		velocity = global_position.direction_to(next_position)*movement_delta





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if animated_sprite_2d.frame == 11:
		animated_sprite_2d.pause()

func big_scary():
	pass

func _on_vision_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		if animated_sprite_2d.frame != 11:
			animated_sprite_2d.play()
		target = body
		state = states.chase
		$roam_timer.autostart = false
		$roam_timer.stop()

func _on_chase_distance_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		target = null
		state = states.roam
		$roam_timer.start()
		$roam_timer.autostart = true

func _on_navigation_timer_timeout() -> void:
	if target:
		navigation_agent_2d.target_position = target.global_position


func _on_roam_timer_timeout() -> void:
	randomize()
	navigation_agent_2d.target_position = Vector2(randf_range(position.x - 128,position.x + 128), randf_range(position.y - 128,position.y + 128))


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		match Global.difficulty:
			Global.Difficulties.Normal:
				print("Normal")
			Global.Difficulties.Hard:
				print("Hard")
