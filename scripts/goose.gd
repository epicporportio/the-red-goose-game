extends CharacterBody2D

var facing = "left"
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite = $Sprite


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flip sprite based on movement direction
	if facing == "left" && Input.is_action_just_pressed("right"):
		sprite.flip_h = true
		facing = "right"
	elif facing == "right" && Input.is_action_just_pressed("left"):
		sprite.flip_h = false
		facing = "left"
	else:
		pass

	move_and_slide()
