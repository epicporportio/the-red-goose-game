extends Node2D

@onready var goose = $Goose
@onready var double_jump = $DoubleJump1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(double_jump)	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_boundary_south_body_entered(body: Node2D) -> void:
	goose.position = Vector2(34.0,-60.0)

func _on_double_jump_doublejump() -> void:
	goose.double_jump = true
	print("double jump")
