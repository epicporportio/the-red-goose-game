extends CharacterBody2D

var facing = "right"
var double_jump = false
const SPEED = 100.0
const JUMP_VELOCITY = -300.0
@onready var sprite = $Sprite
@onready var camera = $Camera
@onready var border = $"../WorldBorder/BoundarySouth"

func _ready() -> void:
	sprite.flip_h = true
	scale = Vector2(0.3,0.3)
	camera.zoom = Vector2(3.0,3.0)

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("jump") and not is_on_floor() and double_jump == true:
		velocity.y = JUMP_VELOCITY
		double_jump = false

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flip sprite based on movement direction
	if facing == "left" and Input.is_action_just_pressed("right"):
		sprite.flip_h = true
		facing = "right"
	elif facing == "right" && Input.is_action_just_pressed("left"):
		sprite.flip_h = false
		facing = "left"
	else:
		pass

	move_and_slide()

	
