extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		set_deferred("monitoring", false)
	pass # Replace with function body.
