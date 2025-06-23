extends Area2D

signal superdash

func _on_body_entered(body: Node2D) -> void:
	superdash.emit()
	queue_free()
