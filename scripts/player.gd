extends CharacterBody2D

@onready var animation: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 80.0
const JUMP_VELOCITY = -300.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play("jump_preparation")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if is_on_floor():
		if animation.animation == 'falling':
			animation.play('landing') # Se estava caindo, toca a animação de aterrissagem
		elif animation.animation != "landing" or not animation.is_playing():
			if direction != 0:
				animation.flip_h = (direction < 0)
				animation.play("run")
			else:
				animation.play("idle")
		
		if direction > 0:
			animation.flip_h = false
			animation.play('run')
		elif direction < 0:
			animation.flip_h = true
			animation.play('run')
		else:
			animation.play('idle')
	else:
		if animation.animation == 'jump_preparation' and animation.is_playing():
		 	# Deixa a animação de preparação terminar.
			pass		
		elif velocity.y < 0:
			animation.play("flying_up")
		elif velocity.y >= 0:
			animation.play("falling")
			
	move_and_slide()
	
