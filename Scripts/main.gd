extends Node3D

@onready var player: CharacterBody3D = %Player
@onready var main_camera: Camera3D = $MainCamera

@export var starting_z:float = 10.0
@export var difficulty:float = 8.0

var total_credits = difficulty * 50  
var current_credits = total_credits

const difficulty_max = 10.0
const BASE_MIN_GAP = 20.0
const BASE_MAX_GAP = 50.0

const EASY_COST_M = 1.0
const MED_COST_M = 2.0
const HARD_COST_M = 4.0

const REFUND_PER_METER = 0.5


var obstacles = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ready_stage()
	start_game()

func ready_stage():
	var total_dist = $BoardingRamp.length - 10.0
	var cur_position = starting_z
	# Raw weights: harder stages → more weight on HARD, less on EASY
	var weight_easy:float = max(0.0, (11.0 - difficulty))      # e.g. at diff=1 → 10; diff=10 → 1
	var weight_hard:float = difficulty                     # e.g. at diff=1 → 1; diff=10 → 10
	var weight_med:float  = (weight_easy + weight_hard) / 2.0

	# Normalize to probabilities
	var sum_w:float = weight_easy + weight_med + weight_hard
	var p_easy:float = weight_easy / sum_w
	var p_med:float  = weight_med  / sum_w
	var p_hard:float = weight_hard / sum_w

	var gap_bias:float = 1.0 - (difficulty - 1) * 0.05   # goes from 1.0 → 0.55
	var min_gap:float = BASE_MIN_GAP * gap_bias
	var max_gap:float = BASE_MAX_GAP * gap_bias
	
	while cur_position < total_dist:
		var remaining_distance = total_dist - cur_position
		var gap_len = randf_range(min_gap, max_gap)
		
		
		current_credits += gap_len * REFUND_PER_METER
		cur_position += gap_len
		
		if cur_position >= total_dist:
			break;
			
		var r = randf()
		var zone_type:Enums.PatternDifficulty
		if   r < p_easy: zone_type = Enums.PatternDifficulty.EASY
		elif r < p_easy + p_med: zone_type = Enums.PatternDifficulty.MED
		else: zone_type = Enums.PatternDifficulty.HARD
		
		var pattern = PatternManager.get_pattern_by_diff(zone_type, remaining_distance)
		if pattern == null:
			break
		place_pattern(pattern, cur_position)
		
	return

func place_pattern(pattern:ObstaclePattern, z_pos:float):
	for ob in pattern.obstacles:
		var n_ob = PatternManager.OBSTACLE.instantiate()
		$BoardingRamp.add_child(n_ob)
		n_ob.type = ob.type
		n_ob.position = Vector3(ob.position.x, ob.position.y, ob.position.z + z_pos)
		n_ob.connect("body_entered", _on_obstacle_body_entered)
	return

func start_game():
	
	SoundBus.song_1.play()
	player.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$"FPS Counter/FPSLabel".text = "FPS: " + str(Engine.get_frames_per_second())
	main_camera.global_position.z = player.global_position.z - 4.0
	pass

# YAY


func _on_obstacle_body_entered(body: Node3D) -> void:
	if body == player:
		player.on_hit_obstacle()
		
	pass # Replace with function body.
