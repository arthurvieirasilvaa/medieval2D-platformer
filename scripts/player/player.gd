extends CharacterBody2D

class_name Player


@export var speed : float = 120.0
@export var death_state : State
@onready var hit_state: HitState = $CharacterStateMachine/Hit


@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var foot_steps_sfx: AudioStreamPlayer = $AudioController/FootSteps
@onready var damageable: Damageable = $Damageable
@onready var death: DeathState = $CharacterStateMachine/Death


const RUBY_HEAL_COST = 5
const HEAL_AMOUNT = 8
const DEATH_Y_LEVEL : float = 300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = 0

signal facing_direction_changed(facing_right : bool)


func _ready() -> void:	
	animation_tree.active = true


func _physics_process(delta: float) -> void:
	check_for_fall_death()
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	direction = Input.get_axis("left", "right")
	if direction != 0 && state_machine.check_if_can_move():
		velocity.x = direction * speed
		
		if is_on_floor():
			if not foot_steps_sfx.playing:
				foot_steps_sfx.play()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
		if not is_on_floor() or direction == 0:
			if not foot_steps_sfx.playing:
				foot_steps_sfx.stop()
	
	move_and_slide()
	update_animation_paramaters()
	update_facing_direction() 


func update_animation_paramaters():
	animation_tree.set("parameters/move/blend_position", direction)
	

func update_facing_direction():
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true
	
	emit_signal("facing_direction_changed", !sprite.flip_h)


func _unhandled_input(event):
	if event.is_action_pressed("heal"):
		attempt_heal()


func attempt_heal():
	if not state_machine.check_if_can_move():
		return
		
	if RubiesController.total_rubies >= RUBY_HEAL_COST:
		if damageable.heal(HEAL_AMOUNT):
			RubiesController.ruby_collected(-RUBY_HEAL_COST)
			print("Cura aplicada! Rubis restantes: ", RubiesController.total_rubies)
		else:
			print("Vida cheia!")
	else:
		print("Rubis insuficientes para curar. Necessário: ", RUBY_HEAL_COST)


func check_for_fall_death():
	if global_position.y > DEATH_Y_LEVEL:
		kill_player()
		

func kill_player():
	var character_state_machine = state_machine
   
	if state_machine.current_state != death:
		state_machine.current_state.next_state = death
