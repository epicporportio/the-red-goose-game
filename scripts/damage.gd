extends Area2D

var damage = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.has_method("enemy_take_damage"):
		parent.enemy_take_damage(damage)
	queue_free()
	
