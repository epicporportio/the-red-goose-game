extends Node2D

var effect_animation = preload("res://scenes/dash_animation.tscn").instantiate()
var double_jump = preload("res://scenes/double_jump.tscn").instantiate()
var super_dash = preload("res://scenes/super_dash.tscn").instantiate()
var damage_zone = preload("res://scenes/damage.tscn").instantiate()

var damage_clone: Area2D = null
var damage_clone_2: Area2D = null

@onready var goose = $Goose
@onready var duck: Node2D = $Duck
@onready var smash_timer: Timer = $SmashTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	duck.scale = Vector2(0.3, 0.3)
	var double_jump_clone = double_jump.duplicate()
	var super_dash_clone = super_dash.duplicate()
	add_child(double_jump_clone)
	add_child(super_dash_clone)
	double_jump_clone.position = Vector2(424.0, -24)
	super_dash_clone.position = Vector2(328.0, -71)
	double_jump_clone.doublejump.connect(_on_double_jump_doublejump)
	super_dash_clone.superdash.connect(_on_super_dash_superdash)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_double_jump_doublejump() -> void:
	goose.double_jump = true

func _on_super_dash_superdash() -> void:
	goose.super_dash = true

func _on_goose_powerup_used(state: Variant, direction: Variant) -> void:
	var effect_animation_clone = effect_animation.duplicate()
	add_child(effect_animation_clone)
	if state == "ground":
		if direction == "right":
			effect_animation_clone.scale.x = 0.5
			effect_animation_clone.scale.y = 0.5
			effect_animation_clone.position = Vector2(goose.position.x - 25.0, goose.position.y - 5.0)
		elif direction == "left":
			effect_animation_clone.scale.x = 0.5
			effect_animation_clone.scale.y = 0.5
			effect_animation_clone.position = Vector2(goose.position.x + 25.0, goose.position.y - 5.0)
	elif state == "air":
		if direction == "right":
			effect_animation_clone.position = Vector2(goose.position.x - 27.0, goose.position.y)
		if direction == "left":
			effect_animation_clone.position = Vector2(goose.position.x + 27.0, goose.position.y)
	elif state == "airjump":
		effect_animation_clone.scale.x = 0.5
		effect_animation_clone.scale.y = 0.5
		effect_animation_clone.position = Vector2(goose.position.x, goose.position.y + 5.0)
	effect_animation_clone.play_animation(state, direction)


func _on_death_to_gravity_body_entered(body: Node2D) -> void:
	if body.has_method("die"):
		get_tree().reload_current_scene()


func _on_goose_smashed() -> void:
	var effect_animation_clone = effect_animation.duplicate()
	var effect_animation_clone_2 = effect_animation.duplicate()
	damage_clone = damage_zone.duplicate()
	damage_clone_2 = damage_zone.duplicate()
	var fall_ratio = (goose.position.y - goose.smash_start_pos) / 100
	var effect_fall_ratio = 2 * fall_ratio
	add_child(effect_animation_clone)
	add_child(effect_animation_clone_2)
	get_tree().get_root().add_child(damage_clone)
	get_tree().get_root().add_child(damage_clone_2)
	
	goose.smash_damage = goose.smash_damage * fall_ratio
	
	#if goose.position.y - goose.smash_start_pos > 150:
		#effect_animation_clone.scale = Vector2(1, 1)
		#effect_animation_clone_2.scale = Vector2(1, 1)
	#else:
	effect_animation_clone.scale = Vector2(effect_fall_ratio, effect_fall_ratio)
	effect_animation_clone_2.scale = Vector2(effect_fall_ratio, effect_fall_ratio)
	
	damage_clone.scale = Vector2(1.5 * effect_fall_ratio, effect_fall_ratio)
	damage_clone_2.scale = Vector2(1.5 * effect_fall_ratio, effect_fall_ratio)
	
	effect_animation_clone.position = Vector2(goose.position.x - 8 - (7 * effect_fall_ratio), goose.position.y + 7 - (15 * effect_fall_ratio))
	effect_animation_clone_2.position = Vector2(goose.position.x + 8 + (7 * effect_fall_ratio), goose.position.y + 7 - (15 * effect_fall_ratio))
	
	damage_clone.position = Vector2(effect_animation_clone.position.x - (15 * effect_fall_ratio), effect_animation_clone.position.y + (effect_fall_ratio))
	damage_clone_2.position = Vector2(effect_animation_clone_2.position.x + (15 * effect_fall_ratio), effect_animation_clone_2.position.y + (effect_fall_ratio))
	damage_clone.damage = goose.smash_damage
	damage_clone_2.damage = goose.smash_damage
	
	effect_animation_clone.play_animation("smash", "right")
	effect_animation_clone_2.play_animation("smash", "left")
	
	goose.smash_damage = goose.DEFAULT_SMASH_DAMAGE
	print(damage_clone_2.position)
	print(damage_clone_2.scale)
	
	smash_timer.start()

func _on_smash_timer_timeout() -> void:
	if damage_clone and is_instance_valid(damage_clone):
		damage_clone.queue_free()
		damage_clone = null
	if damage_clone_2 and is_instance_valid(damage_clone_2):
		damage_clone_2.queue_free()
		damage_clone_2 = null


func _on_second_life_secondlife() -> void:
		goose.scale = Vector2(goose.scale.x * 1.5, goose.scale.y * 1.5)
		goose.second_life = true
		goose.killable = false
