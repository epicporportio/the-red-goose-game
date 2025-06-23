extends CharacterBody2D

var facing = "right"
var double_jump = false
var super_dash = false
var is_dashing = false
var speed := 100.0
var jump_velocity := -300.0

const DEFAULT_SPEED = 100.0
const DEFAULT_JUMP_VELOCITY = -300.0
const DEFAULT_DASH_TIME = 0.1

@onready var sprite = $Sprite
@onready var camera = $Camera
@onready var border = $"../WorldBorder/BoundarySouth"
@onready var dash_timer = $DashTimer

func _ready() -> void:
	sprite.flip_h = true
	scale = Vector2(0.3,0.3)
	camera.zoom = Vector2(3.0,3.0)

func _physics_process(delta: float) -> void:
	
	var direction := Input.get_axis("left", "right")
	
	# Add the gravity.
	if not is_on_floor() and is_dashing == false:
		velocity += get_gravity() * delta

	# Handle dash
	if direction:
		if Input.is_action_just_pressed("dash"):
			if super_dash == true:
				dash_timer.wait_time = 0.2
				super_dash = false
			else:
				dash_timer.wait_time = DEFAULT_DASH_TIME
			dash_timer.start()
			is_dashing = true

	if is_dashing == true:
		speed = 800.0
		velocity.x = direction * speed
		move_and_slide()

	elif is_dashing == false:
		# Handle jump.
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
		if Input.is_action_just_pressed("jump") and not is_on_floor() and double_jump == true:
			velocity.y = jump_velocity
			double_jump = false

		# Get the input direction and handle the movement/deceleration.
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)

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

func _on_dash_timer_timeout() -> void:
	speed = DEFAULT_SPEED
	is_dashing = false
