extends Area2D

signal superdash

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("die") and body.super_dash == false:
		superdash.emit()
		#queue_free()
