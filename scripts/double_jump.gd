extends Area2D

signal doublejump

func _on_body_entered(body: Node2D) -> void:
	doublejump.emit()
	queue_free()
