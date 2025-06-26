extends Node2D

signal damage_taken

var speed = 30.0
var health = 100.0
var direction = -1
var is_dying = false
var killable = true

@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var death: Area2D = $Death
@onready var iframes: Timer = $Iframes

func _process(delta: float) -> void:
	if is_dying == false:
		# Handle death
		if health <= 0:
			death.queue_free()
			enemy_die()
			is_dying = true
		# Handle movement
		if ray_cast_left.is_colliding():
			sprite.flip_h = true
			direction = 1
		elif ray_cast_right.is_colliding():
			sprite.flip_h = false
			direction = -1
		position.x += direction * speed * delta

func enemy_take_damage(damage):
	if killable == true:
		health -= damage
		damage_taken.emit()
		iframes.start()
		killable = false
		print("damage taken: ", damage)

func enemy_die():
	sprite.play("die")

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()

func _on_iframes_timeout() -> void:
	killable = true
