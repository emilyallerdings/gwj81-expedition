extends Node3D

signal player_entered

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		player_entered.emit()
