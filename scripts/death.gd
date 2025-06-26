extends Area2D

@onready var death_timer: Timer = $DeathTimer

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die") and body.killable == true:
		body.die()
		body.sprite.play("die")
		death_timer.start()
	elif body.has_method("die") and body.killable == false and body.second_life == true:
		body.lose_life()
	
func _on_death_timer_timeout() -> void:
	get_tree().reload_current_scene()
