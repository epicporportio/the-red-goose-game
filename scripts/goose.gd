extends CharacterBody2D

signal powerup_used(state, direction)
signal smashed

var facing = "right"
var double_jump = false
var super_dash = false
var second_life = false

var is_dashing = false
var is_smashing = false
var is_dying = false

var killable = true
var speed := 100.0
var jump_velocity := -300.0
var smash_damage = 150.0
var state = "ground"
var smash_start_pos

const DEFAULT_SPEED = 100.0
const DEFAULT_JUMP_VELOCITY = -300.0
const DEFAULT_DASH_TIME = 0.1
const DEFAULT_DASH_SPEED = 800.0
const DEFAULT_SMASH_SPEED = 1000.0
const DEFAULT_SMASH_DAMAGE = 150.0

@onready var sprite = $Sprite
@onready var camera = $Camera
@onready var dash_timer = $DashTimer
@onready var goose_collision: CollisionShape2D = $GooseCollision
@onready var bounce: Area2D = $Bounce

func _ready() -> void:
	is_dying = false
	sprite.animation = "default"
	sprite.flip_h = true
	scale = Vector2(0.3,0.3)
	camera.zoom = Vector2(3.0,3.0)

func _physics_process(delta: float) -> void:
	if is_dying == false:
		var direction := Input.get_axis("left", "right")
		
		# Add the gravity.
		if not is_on_floor() and is_dashing == false:
			velocity += get_gravity() * delta

		# Handle dash
		if direction:
			if Input.is_action_just_pressed("dash"):
				if is_on_floor():
					state = "ground"
				else:
					state = "air"
				powerup_used.emit(state, facing)
				if super_dash == true:
					dash_timer.wait_time = 0.2
				else:
					dash_timer.wait_time = DEFAULT_DASH_TIME
				dash_timer.start()
				is_dashing = true

		if is_dashing == true:
			if super_dash == true:
				speed = 1600.0
				super_dash = false
			else:
				speed = DEFAULT_DASH_SPEED
			velocity.x = direction * speed
			move_and_slide()

		elif is_dashing == false:
			# Handle jump.
			if Input.is_action_pressed("jump") and is_on_floor():
				velocity.y = jump_velocity
			if Input.is_action_just_pressed("jump") and not is_on_floor() and double_jump == true:
				velocity.y = jump_velocity
				double_jump = false
				state = "airjump"
				powerup_used.emit(state, facing)
			# Handle smash
			if Input.is_action_just_pressed("down"):
				if not is_on_floor():
					is_smashing = true
					smash_start_pos = position.y
				elif is_on_floor():
					pass #drop thru
					
			if is_smashing == true:
				bounce.position = Vector2(0.0, 45.0)
				bounce.scale = Vector2(2.5, 2.0)
				direction = 0
				velocity.y = DEFAULT_SMASH_SPEED
			
			if is_on_floor() and is_smashing == true:
				velocity.y = 0
				smashed.emit()
				is_smashing = false
				bounce.position = Vector2(0, 33)
				bounce.scale = Vector2(2.5, 0.8)

			# Get the input direction and handle the movement/deceleration.
			if direction:
				velocity.x = direction * speed
			else:
				velocity.x = move_toward(velocity.x, 0, speed)

			# Flip sprite based on movement direction
			if facing == "left" and Input.is_action_pressed("right"):
				sprite.flip_h = true
				facing = "right"
			elif facing == "right" && Input.is_action_pressed("left"):
				sprite.flip_h = false
				facing = "left"
			else:
				pass

			move_and_slide()

func _on_dash_timer_timeout() -> void:
	speed = DEFAULT_SPEED
	is_dashing = false
	
func die():
	is_dying = true
	
func lose_life():
	scale = Vector2(scale.x / 1.5, scale.y / 1.5)
	second_life = false
	killable = true

func _on_sprite_animation_finished() -> void:
	get_tree().reload_current_scene()

func _on_bounce_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if area.get_parent().has_method("enemy_die") and area.has_method("obliterate"):
		killable = false
		is_smashing = false
		velocity.y = jump_velocity
		area.get_parent().enemy_take_damage(10000000.0)
		killable = true
