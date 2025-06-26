extends Area2D

signal doublejump

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die") and body.double_jump == false:
		doublejump.emit()
		#queue_free()
