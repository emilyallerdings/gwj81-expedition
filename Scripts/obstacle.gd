extends StaticBody3D 
class_name Obstacle

@export var type:Enums.ObstacleType

@onready var animation_player = $"Character Mesh/AnimationPlayer"

func _ready():
	animation_player.play("character_anim_idle_02/Idle_02")
