@tool
extends Node3D

@export var width := 10.0
@export var length := 200.0

@export_tool_button("Resize", "Callable") var set_size_btn = set_size

@onready var roof: StaticBody3D = $Roof
@onready var roof_mesh: MeshInstance3D = $Roof/RoofMesh


@onready var floor_mesh: MeshInstance3D = $Floor/FloorMesh
@onready var floor: StaticBody3D = $Floor

@onready var side_left: StaticBody3D = $SideLeft
@onready var side_left_mesh: MeshInstance3D = $SideLeft/SideLeftMesh
@onready var side_left_coll: CollisionShape3D = $SideLeft/SideLeftColl


@onready var side_right: StaticBody3D = $SideRight
@onready var side_right_mesh: MeshInstance3D = $SideRight/SideRightMesh
@onready var side_right_coll: CollisionShape3D = $SideRight/SideRightColl


@onready var pillars_left: MultiPillar = $PillarsLeft
@onready var pillars_right: MultiPillar = $PillarsRight

@onready var window_left: MeshInstance3D = $WindowLeft
@onready var window_right: MeshInstance3D = $WindowRight


var total_credits = 0
var current_credits = 0

const difficulty_max = 13.0
const BASE_MIN_GAP = 30.0
const BASE_MAX_GAP = 50.0

const EASY_COST_M = 1.0
const MED_COST_M = 2.0
const HARD_COST_M = 3.0

const REFUND_PER_METER = 0.5


var obstacles = []

var prev_pattern = null

func fill_obstacles():
	total_credits = 0.5 * length
	ready_stage(GameManager.base_difficulty + GameManager.modifier_difficulty +  + GameManager.base_diff_mod)
	#print(GameManager.base_difficulty)
	#print(GameManager.modifier_difficulty)

func set_size():
	
	self.position.y = 3.0
	floor_mesh.mesh.size.z = length
	floor_mesh.mesh.size.x = width
	floor.position.z = (length / 2.0)
	
	roof_mesh.mesh.size.z = length
	roof_mesh.mesh.size.x = width
	roof.position.z = (length / 2.0)

	side_left_mesh.mesh.size.z = length
	side_left_coll.shape.size.z = length
	side_left.position.z = (length / 2.0)
	side_left.position.x = width/2.0
	
	side_right_mesh.mesh.size.z = length
	side_right_coll.shape.size.z = length
	side_right.position.z = (length / 2.0)
	side_right.position.x = -width/2.0
	
	window_left.mesh.size.z = length
	window_left.position.z = (length / 2.0)
	window_left.position.x = width/2.0	
	
	window_right.mesh.size.z = length
	window_right.position.z = (length / 2.0)
	window_right.position.x = -width/2.0
	
	pillars_left.position.x = width/2.0
	pillars_right.position.x = -width/2.0
	
	await get_tree().create_timer(0.1)
	pillars_left.remesh(int(ceil(length/4)) + 1)
	await get_tree().create_timer(0.1)
	pillars_right.remesh(int(ceil(length/4)) + 1)
	await get_tree().create_timer(0.1)
	
func ready_stage(difficulty):
	var starting_pos = 5.0
	var total_dist = length - 5.0
	var cur_position = starting_pos
	# Raw weights: harder stages → more weight on HARD, less on EASY
	var weight_easy:float = max(0.0, (13.0 - difficulty))      # e.g. at diff=1 → 10; diff=10 → 1
	var weight_hard:float = difficulty                     # e.g. at diff=1 → 1; diff=10 → 10
	var weight_med:float  = (weight_easy + weight_hard) / 2.0

	# Normalize to probabilities
	var sum_w:float = weight_easy + weight_med + weight_hard
	var p_easy:float = weight_easy / sum_w
	var p_med:float  = weight_med  / sum_w
	var p_hard:float = weight_hard / sum_w

	var gap_bias:float = 1.0 - (difficulty - 1) * 0.075   # goes from 1.0 → 0.55
	var min_gap:float = max(4, BASE_MIN_GAP * gap_bias)
	var max_gap:float = max(4, BASE_MAX_GAP * gap_bias)
	
	
	while cur_position < total_dist:
		var remaining_distance = total_dist - cur_position
		var gap_len = randf_range(min_gap, max_gap)
		
		
		current_credits += gap_len * REFUND_PER_METER
		cur_position += gap_len
		
		if cur_position >= total_dist:
			break;
			
		var r = randf()
		if GameManager.base_difficulty == 0:
			r = 0.0
		var zone_type:Enums.PatternDifficulty
		if   r < p_easy: zone_type = Enums.PatternDifficulty.EASY
		elif r < p_easy + p_med: zone_type = Enums.PatternDifficulty.MED
		else: 
			if GameManager.base_difficulty < Enums.LevelDifficulty.MEDIUM:
				zone_type = Enums.PatternDifficulty.HARD
			else:
				zone_type = Enums.PatternDifficulty.MED
		
		var pattern = PatternManager.get_pattern_by_diff(zone_type, remaining_distance + 4, prev_pattern)
		if pattern == null:
			break
		prev_pattern = pattern
		place_pattern(pattern, cur_position)
		cur_position += pattern.length * 1.5
	return

func place_pattern(pattern:ObstaclePattern, z_pos:float):
	for ob in pattern.obstacles:
		
		var n_ob
		if ob.type == Enums.ObstacleType.PEOPLE:
			n_ob = PatternManager.OBSTACLE.instantiate()
		elif ob.type == Enums.ObstacleType.PICKUP:
			#n_ob = PatternManager.PICKUP.instantiate()
			pass
		elif ob.type == Enums.ObstacleType.CRATE:
			print("test")
			n_ob = PatternManager.CRATE.instantiate()
			pass
		if n_ob:
			obstacles.append(n_ob)
			add_child(n_ob)
			n_ob.type = ob.type
			n_ob.position = Vector3(ob.position.x, ob.position.y, ob.position.z + z_pos)
		#n_ob.connect("body_entered", _on_obstacle_body_entered)
	return
