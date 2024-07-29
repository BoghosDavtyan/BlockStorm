extends CharacterBody2D

const WALK_SPEED = 150.0
const RUN_SPEED = 250.0
const JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	
	# Check if the run action is pressed
	var is_running = Input.is_action_pressed("run")
	
	# Flip character
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animations
	if direction == 0:
		animated_sprite.play("Idle")
	elif is_running:
		animated_sprite.play("Running")
	else:
		animated_sprite.play("Walking")
	
	# Set speed based on whether the character is running or walking
	var speed = RUN_SPEED if is_running else WALK_SPEED
	
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
