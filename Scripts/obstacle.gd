extends StaticBody3D 
class_name Obstacle

@export var type:Enums.ObstacleType

@onready var animation_player:AnimationPlayer = $"Character Mesh/AnimationPlayer"

func _ready():
	if animation_player != null:
		if animation_player.has_animation("character_anim_idle_02/Idle_02"):
			animation_player.play("character_anim_idle_02/Idle_02")
