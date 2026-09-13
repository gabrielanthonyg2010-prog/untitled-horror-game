extends CharacterBody2D

@onready var vision_circle: CollisionShape2D = $Vision/CollisionShape2D
@onready var chase_circle: CollisionShape2D = $ChaseDistance/CollisionShape2D
@onready var navigation_timer: Timer = $navigation_timer
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var vision: Area2D = $Vision
@onready var chase_distance: Area2D = $ChaseDistance
const SPEED = 75.0
enum states{
	idle,
	chase,
	roam
}
var chances = 0
var movement_delta: float
var target = null
var next_position: Vector2
var state = states.idle
var ccircle: int
var first_time: bool = true
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
				roam(128)
				_on_roam_timer_timeout()
		next_position = navigation_agent_2d.get_next_path_position()
		velocity = global_position.direction_to(next_position)*movement_delta


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if animated_sprite_2d.frame == 11:
		animated_sprite_2d.pause()
	match Global.difficulty:
		Global.Difficulties.Normal:
			vision_circle.shape.radius = 125 + Global.cats_acquired*25
			chase_circle.shape.radius = 225 + Global.cats_acquired*25
			ccircle = 225 + Global.cats_acquired*25
		Global.Difficulties.Hard:
			vision_circle.shape.radius = 1025 + Global.cats_acquired*250
			chase_circle.shape.radius = 2025 + Global.cats_acquired*250
			ccircle = 2025 + Global.cats_acquired*250

func big_scary():
	pass

func _on_vision_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		if first_time:
			first_time = false
			$FreesoundCommunityJumpscare94984.play()
		target = body
		state = states.chase
		$roam_timer.stop()

func _on_chase_distance_body_entered(body: Node2D) -> void:
	if animated_sprite_2d.frame != 11:
		animated_sprite_2d.play()
		target = body
		state = states.chase


func _on_chase_distance_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		target = null
		$roam_timer.start()
		$time_since_player.start()

func _on_navigation_timer_timeout() -> void:
	if target:
		navigation_agent_2d.target_position = target.global_position


func _on_roam_timer_timeout() -> void:
	state = states.roam

func roam(distance: float):
	var theta: float = randf_range(0,TAU)
	var target_pos_x: float = clamp(position.x + distance*cos(theta), 0, Global.maze_width*32)
	var target_pos_y: float = clamp(position.y + distance*sin(theta), 0, Global.maze_height*32)
	navigation_agent_2d.target_position = Vector2(target_pos_x,target_pos_y)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		match Global.difficulty:
			Global.Difficulties.Normal:
				if chances < 2 and vision.monitoring == true:
					roam(ccircle)
					vision.monitoring = false
					chase_distance.monitoring = false
					chances+=1
					$safe_for_player.start()
				if vision.monitoring == true:
					SceneTransitionScene.change_scene("res://scenes/game_over.tscn")
			Global.Difficulties.Hard:
				SceneTransitionScene.change_scene("res://scenes/game_over.tscn")


func _on_time_since_player_timeout() -> void:
	roam(ccircle*4)

func _on_safe_for_player_timeout() -> void:
	vision.monitoring = true
	chase_distance.monitoring = true
