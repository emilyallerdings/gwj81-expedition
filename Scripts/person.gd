extends Obstacle
class_name Person

@onready var animation_player:AnimationPlayer = $"Character Mesh/AnimationPlayer"

func _ready():
	$"Character Mesh/AnimationPlayer".speed_scale = randf_range(0.9,1.1)
	$"Character Mesh/Skeleton3D/Character_Mesh".mesh.surface_get_material(0).set_shader_parameter("new_color", Vector4(randf(), randf(), randf(), 1.0))
	pass

func set_vis(bol):
	super(bol)
	if bol:
		if !animation_player.is_playing():
			animation_player.play("character_anim_idle_02/Idle_02")
	else:
		animation_player.stop(true)

func on_hit():
	$"Character Mesh/AnimationPlayer".play("character_anim_oof/Oof")
	SoundBus.oof.play()
	await animation_player.animation_finished
	animation_player.play("character_anim_idle_02/Idle_02")
