extends CharacterBody2D

enum KnightState {
	idle,
	walk,
	attack1,
	hurt,
	death
}

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector
@onready var player_detector: RayCast2D = $PlayerDetector
@onready var attack_box: Area2D = $AttackBox

@export var max_hp = 40
@export var min_hp = 0
var hp = max_hp

@export var attack1_damage = 10 
@export var attack2_damage = 20
@export var attack3_damage = 30

var can_damage_player = false

const SPEED = 30.0
const JUMP_VELOCITY = -400.0

var status: KnightState

var direction = 1

 

func _ready() -> void:
	attack_box.monitoring = false
	go_to_walk_state()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		KnightState.idle:
			idle_state(delta)
		KnightState.walk:
			walk_state(delta)
		KnightState.attack1:
			attack1_state(delta)
		KnightState.hurt:
			hurt_state(delta)
		KnightState.death:
			death_state(delta)

	move_and_slide()


func go_to_idle_state():
	status = KnightState.idle
	animation.play("idle")
	

func go_to_walk_state():
	status = KnightState.walk
	animation.play("walk")
	
	
func go_to_attack1_state():
	status = KnightState.attack1
	animation.play("attack1")	
	velocity = Vector2.ZERO
	attack_box.monitoring = true
	
	
func go_to_hurt_state():
	status = KnightState.hurt
	animation.play("hurt")
	velocity = Vector2.ZERO
		

func go_to_death_state():
	status = KnightState.death
	animation.play("death")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO
	attack_box.monitoring = false


func idle_state(_delta):
	pass
	
	
func walk_state(_delta):
	velocity.x = SPEED * direction
	
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
	
	if player_detector.is_colliding():
		go_to_attack1_state()
		return
		

func attack1_state(_delta):
	pass


func hurt_state(delta):
	pass


func death_state(_delta):
	pass


func take_damage(damage):
	if status != KnightState.death:
		hp -= damage
		if hp <= 0:
			go_to_death_state()
		else:	
			go_to_hurt_state()


func enable_attack_box():
	attack_box.monitoring = true


func disable_attack_box():
	attack_box.monitoring = false


func _on_animated_sprite_2d_animation_finished() -> void:
	if animation.animation == "attack1":
		go_to_walk_state()
		return
		

func _on_attack_box_area_entered(area: Area2D) -> void:
	if can_damage_player and area.is_in_group("Player_Hitbox"):
		if status == KnightState.attack1:
			area.get_parent().take_damage(attack1_damage)
			can_damage_player = false


func _on_animated_sprite_2d_frame_changed() -> void:
	if animation.animation == "attack1":
		if animation.frame == 3 or animation.frame == 4 or animation.frame == 5:
			enable_attack_box()
			can_damage_player = true
		else:
			disable_attack_box()
