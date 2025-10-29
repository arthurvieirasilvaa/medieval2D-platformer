extends CharacterBody2D

enum PlayerState {
	idle,
	walk,
	jump_preparation,
	flying_up,
	falling,
	landing,
	crouch,
	sliding,
	attack,
	combo_attack,
	critical_attack,
	taking_damage,
	death
}

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var reload_timer: Timer = $ReloadTimer


@export var max_speed = 120.0
@export var acceleration = 400
@export var deceleration = 400
@export var slide_deceleration = 100
@export var max_hp = 100
@export var min_hp = 0
var hp = max_hp

var attack_stage = 0 # 0 = nenhum ataque, 1 = attack, 2 = combo attack e 3 = critical attack
var can_chain_combo = false
var attack_damage = 10
var combo_attack_damage = 15
var critical_attack_damage = 20

const JUMP_VELOCITY = -300.0

var jump_count = 0
@export var max_jump_count = 2
var direction = 0
var status: PlayerState




func _ready() -> void:
	go_to_idle_state()


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		PlayerState.idle:
			idle_state(delta)
		PlayerState.walk:
			walk_state(delta)
		PlayerState.jump_preparation:
			jump_preparation_state(delta)
		PlayerState.flying_up:
			flying_up_state(delta)
		PlayerState.falling:
			falling_state(delta)
		PlayerState.landing:
			landing_state(delta)
		PlayerState.crouch:
			crouch_state(delta)
		PlayerState.sliding:
			sliding_state(delta)
		PlayerState.attack:
			attack_state(delta)
		PlayerState.combo_attack:
			combo_attack_state(delta)
		PlayerState.critical_attack:
			critical_attack_state(delta)
		PlayerState.taking_damage:
			taking_damage_state(delta)
		PlayerState.death:
			death_state(delta)
		
	move_and_slide()


func go_to_idle_state():
	status = PlayerState.idle
	animation.play("idle")


func go_to_walk_state():
	status = PlayerState.walk
	animation.play("walk")
	

func go_to_jump_preparation_state():
	status = PlayerState.jump_preparation	
	animation.play("jump_preparation")
	

func go_to_flying_up_state():
	status = PlayerState.flying_up
	velocity.y = JUMP_VELOCITY
	animation.play("flying_up")
	jump_count += 1


func go_to_falling_state():
	status = PlayerState.falling
	animation.play("falling")


func go_to_landing_state():
	status = PlayerState.landing
	animation.play("landing")
	
	
func go_to_crouch_state():
	status = PlayerState.crouch
	animation.play("crouch")
	set_crouch_collider()


func exit_from_crouch_state():
	set_large_collider()


func go_to_sliding_state():
	status = PlayerState.sliding
	animation.play("sliding")
	set_sliding_collider()
	

func exit_from_sliding_state():
	set_large_collider()


func go_to_attack_state():
	status = PlayerState.attack
	animation.play("attack")
	attack_stage = 1
	set_attack_collider()
	enable_attack_box()


func exit_from_attack_state():
	set_large_collider()


func go_to_combo_attack_state():
	status = PlayerState.combo_attack
	animation.play("combo_attack")
	attack_stage = 2
	enable_attack_box()
	

func go_to_critical_attack_state():
	status = PlayerState.critical_attack
	animation.play("critical_attack")
	attack_stage = 3
	enable_attack_box()
	
	
func go_to_taking_damage_state():
	print("dano")
	status = PlayerState.taking_damage
	animation.play("taking_damage")
	
	
func go_to_death_state():
	status = PlayerState.death
	animation.play("death")		
	velocity = Vector2.ZERO
	reload_timer.start()
	
	
func idle_state(delta):
	move(delta)
	
	if velocity.x != 0:
		go_to_walk_state()
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		go_to_jump_preparation_state()
		return	

	if Input.is_action_pressed("crouch") and is_on_floor():
		go_to_crouch_state()
		return
	
	if Input.is_action_just_pressed("attack") and is_on_floor():
		go_to_attack_state()
		return


func walk_state(delta):
	move(delta)
	
	if velocity.x == 0:
		go_to_idle_state()
		return
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		go_to_jump_preparation_state()
		return
	
	if !is_on_floor():
		jump_count += 1
		go_to_falling_state()
		return
		
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		go_to_sliding_state()
		return

	
func jump_preparation_state(delta):
	move(delta)
	
	if animation.frame == animation.sprite_frames.get_frame_count("jump_preparation") - 1:
		go_to_flying_up_state()
		return


func flying_up_state(delta):
	move(delta)
	
	if Input.is_action_just_pressed("jump") and can_jump():
		go_to_flying_up_state()
		return
		
	if velocity.y > 0:
		go_to_falling_state()
		return	
		
	if is_on_floor():
		go_to_landing_state()
		return


func falling_state(delta):
	move(delta)

	if Input.is_action_just_pressed("jump") and can_jump():
		go_to_flying_up_state()
		return
	
	if is_on_floor():
		go_to_landing_state()
		return

func landing_state(delta):
	move(delta)

	if animation.frame == animation.sprite_frames.get_frame_count("landing") - 1:
		jump_count = 0
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return


func crouch_state(_delta):
	update_direction()
	
	if Input.is_action_just_released("crouch"):
		exit_from_crouch_state()
		go_to_idle_state();
		return
	
	
func sliding_state(delta):
	velocity.x = move_toward(velocity.x, 0, slide_deceleration * delta)	
	
	if Input.is_action_just_released("crouch"):
		exit_from_sliding_state()
		go_to_walk_state()
		return
		
	if velocity.x == 0:
		exit_from_sliding_state()
		go_to_crouch_state()
		return


func attack_state(delta):
	move(delta)
	
	if can_chain_combo and Input.is_action_just_pressed("attack"):
		go_to_combo_attack_state()
		return
	
	if animation.frame == animation.sprite_frames.get_frame_count("attack") - 1:
		stage_after_attacks()
		
		
func combo_attack_state(delta):
	move(delta)
	
	if can_chain_combo and Input.is_action_just_pressed("attack"):
		go_to_critical_attack_state()
		return
	
	if animation.frame == animation.sprite_frames.get_frame_count("combo_attack") - 1:
		stage_after_attacks()


func critical_attack_state(delta):
	move(delta)
	
	if animation.frame == animation.sprite_frames.get_frame_count("critical_attack") - 1:
		stage_after_attacks()


func stage_after_attacks():
	exit_from_attack_state()
	disable_attack_box()
	can_chain_combo = false
	attack_stage = 0
		
	if is_on_floor():
		if abs(velocity.x) > 0:
			go_to_walk_state()
			return
		else:
			go_to_idle_state()
			return
	else:
		if velocity.y < 0:
			go_to_flying_up_state()
			return
		else:
			go_to_falling_state()
			return


func taking_damage_state(delta):
	move(delta)
	
	if is_on_floor():
		if velocity.x != 0:
			go_to_walk_state()
			return
	else:
		if velocity.y < 0:
			go_to_flying_up_state()
			return
		else:
			go_to_falling_state()
			return
	
	
func death_state(_delta):
	pass	
		
	
func move(delta):
	update_direction()
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)	
	

func update_direction():
	direction = Input.get_axis("left", "right")
	
	if direction < 0:
		animation.flip_h = true
	elif direction > 0:
		animation.flip_h = false


func can_jump() -> bool:
	return jump_count < max_jump_count


func set_crouch_collider():
	collision_shape.shape.radius = 12
	collision_shape.shape.height = 25
	collision_shape.position.y = 1
	
	
func set_sliding_collider():
	collision_shape.shape.radius = 13
	collision_shape.shape.height = 26
	collision_shape.position.y = 5


func set_attack_collider():
	collision_shape.shape.radius = 14
	collision_shape.shape.height = 34
	collision_shape.position.x = -2
	collision_shape.position.y = -5


func set_large_collider():
	collision_shape.shape.radius = 14
	collision_shape.shape.height = 32
	collision_shape.position.y = 6


func take_damage(damage):
	if status != PlayerState.death:
		hp -= damage
		if hp <= 0:
			go_to_death_state()
		else:	
			go_to_taking_damage_state()


func _on_reload_timer_timeout() -> void:
	get_tree().reload_current_scene()


func _on_attack_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy_Hitbox"):
		match status:
			PlayerState.attack:
				area.get_parent().take_damage(attack_damage)
			PlayerState.combo_attack:
				area.get_parent().take_damage(combo_attack_damage)
			PlayerState.critical_attack:
				area.get_parent().take_damage(critical_attack_damage)


func enable_attack_box():
	$AttackBox.monitoring = true

func disable_attack_box():
	$AttackBox.monitoring = false


func _on_animated_sprite_2d_frame_changed() -> void:
	match animation.animation:
		"attack":
			if animation.frame in [3, 4, 5]:
				enable_attack_box()
			else:
				disable_attack_box()
		
			can_chain_combo = animation.frame >= 4
		
		"combo_attack":
			if animation.frame in [1, 2]:
				enable_attack_box()
			else:
				disable_attack_box()
			
			can_chain_combo = (animation.frame == 2)
		
		"critical_attack":
			if animation.frame in [2, 3, 4, 5, 6]:
				enable_attack_box()
			else:
				disable_attack_box()
			
			can_chain_combo = false
