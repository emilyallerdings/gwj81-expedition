extends Obstacle
class_name Person

@onready var animation_player:AnimationPlayer = $"Character Mesh/AnimationPlayer"

func _ready():
	pass

func set_vis(bol):
	super(bol)
	if bol:
		if !animation_player.is_playing():
			animation_player.play("character_anim_idle_02/Idle_02")
	else:
		animation_player.stop(true)
