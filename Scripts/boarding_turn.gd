extends Node3D

signal player_entered

func _ready() -> void:
	$Blocker/Blocker_Col.disabled = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		$Blocker/Blocker_Col.disabled = false
		player_entered.emit()
