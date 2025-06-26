extends AnimatedSprite2D

func play_animation(animation, direction):
	if direction == "right":
		flip_h = false
	elif direction == "left":
		flip_h = true
	play(animation)


func _on_animation_finished() -> void:
	queue_free()
