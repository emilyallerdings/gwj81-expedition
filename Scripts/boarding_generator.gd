@tool
extends Node3D
class_name BoardingGenerator

signal player_left_turn
signal player_right_turn
signal player_finished


signal finished_generation

@export_category("Generation")
@export var seed:int = 0
@export var total_path:int = 300
@export var editor_difficulty = 5
@export_tool_button("Randomize Seed", "AudioStreamRandomizer") var rand_seed = randomize_seed
@export_tool_button("Generate", "AudioStreamRandomizer") var gen = generate

const AIRPLANE_END_GENERATE = preload("res://Scenes/airplane_end_generate.tscn")
const END_ZONE = preload("res://Scenes/end_zone.tscn")
const BOARDING_RAMP = preload("res://Scenes/boarding_ramp.tscn")
const BOARDING_TURN_LEFT = preload("res://Scenes/boarding_turn_left.tscn")
const BOARDING_TURN_RIGHT = preload("res://Scenes/boarding_turn_right.tscn")
var cur_loading = false

var right_turns = []
var left_turns = []

var ramps = []

func randomize_seed():
	seed = (Time.get_ticks_msec() * 98765) % 12345678
	property_list_changed.emit()

func generate():
	if cur_loading:
		return

	var rng = RandomNumberGenerator.new()
	rng.seed = seed
	seed(seed)
	
	if Engine.is_editor_hint():
		total_path =  200 + 10 * randi_range(10,5*editor_difficulty + 30)
	else:
		total_path =  200 + 10 * randi_range(10,13) * (GameManager.base_difficulty + GameManager.modifier_difficulty)
		
	right_turns = []
	left_turns = []
	
	cur_loading = true
	
	await get_tree().process_frame
	
	var nodes = get_children(true)
		
	for node in nodes:
		node.call_deferred("queue_free")
		
	await get_tree().process_frame
	await get_tree().process_frame
	
	
	var num_segs = rng.randi_range(2, total_path/75)
	#print("segs: ", num_segs)
	
	
	var segment_lens = []
	segment_lens.resize(num_segs)
	segment_lens.fill(50)
	
	var len_remaining = total_path - 75*num_segs
	
	#print("len_rem:",len_remaining, " = ", total_path, " - 50*", num_segs)
	
	var breakpoints = []
	for i in range(0, num_segs-1):
		breakpoints.append(randi_range(0,len_remaining))
	
	breakpoints.sort()
	#print("breakpoints:", breakpoints)
	var diff = []
	var current_pos = Vector3.ZERO
	var forward_dir = Vector3.BACK
	var turn_dir = [Vector3.LEFT, Vector3.RIGHT]
	if breakpoints.size() > 0:
		diff.append(breakpoints[0])
		for i in range(1, num_segs-1):
			diff.append(breakpoints[i] - breakpoints[i-1])
		diff.append(len_remaining - breakpoints[breakpoints.size()-1])
		#print("diffs: ", diff)
		diff.shuffle()
		for i in range(0, num_segs):
			segment_lens[i] += diff[i]
			segment_lens[i] = snappedi(segment_lens[i], 4)
	else:
		segment_lens[0] = len_remaining
	#print(segment_lens)
	#print (turn_dir)
	var start = BOARDING_RAMP.instantiate()
	add_child(start)
	await get_tree().process_frame
	start.position = current_pos - (4 * forward_dir)
	start.length
	await get_tree().process_frame
	start.set_size()
	await get_tree().process_frame
	
	var counter = 0
	for seg_len in segment_lens:
		await get_tree().create_timer(0.11).timeout
		counter += 1
		var new_ramp = BOARDING_RAMP.instantiate()
		new_ramp.name = "BoardRamp " + str(counter)
		
		await get_tree().process_frame
		add_child(new_ramp)
		await get_tree().process_frame
		new_ramp.owner = self
		new_ramp.position = current_pos
		new_ramp.length = seg_len
		new_ramp.set_size()
		new_ramp.fill_obstacles()
		if forward_dir == Vector3.LEFT:
			new_ramp.rotation.y = deg_to_rad(-90)
		elif forward_dir == Vector3.RIGHT:
			new_ramp.rotation.y = deg_to_rad(90)
			
		ramps.append(new_ramp)
		
		if counter == segment_lens.size():
			current_pos += seg_len * forward_dir
			var end_zone = END_ZONE.instantiate()
			var end_ramp = BOARDING_RAMP.instantiate()
			end_ramp.name = "BoardRampEnd"
			
			
			add_child(end_ramp)
			end_ramp.owner = self
			end_ramp.position = current_pos
			end_ramp.length = 36
			end_ramp.set_size()
			if forward_dir == Vector3.LEFT:
				end_ramp.rotation.y = deg_to_rad(-90)
			elif forward_dir == Vector3.RIGHT:
				end_ramp.rotation.y = deg_to_rad(90)
			
			
			current_pos += 16 * forward_dir
			add_child(end_zone)
			end_zone.position = current_pos
			end_zone.owner = self
			end_zone.connect("body_entered", body_entered_end_zone)
			current_pos += 20 * forward_dir
			var plane = AIRPLANE_END_GENERATE.instantiate()
			add_child(plane)
			#plane.position = end_zone.position + Vector3(-55, -1, 26)
			plane.position = current_pos
			plane.rotation_degrees = end_ramp.rotation_degrees + Vector3(0, -90, 0)
			#plane.scale = Vector3(8, 8, 8)
			plane.owner = self
			#print("end")
			break
			

		#
		#print("cur: ", current_pos, " += ", seg_len, " * ", forward_dir)
		current_pos += seg_len * forward_dir
		var prev_dir = forward_dir
		
		if forward_dir == Vector3.BACK:
			forward_dir = turn_dir.pick_random()
			if forward_dir == Vector3.LEFT:
				var turn = BOARDING_TURN_RIGHT.instantiate()
				
				
				add_child(turn)
				turn.owner = self
				
				turn.name = "Turn Right"
				
				turn.position = current_pos + Vector3(0,3,0)
				
				left_turns.append(turn)
			elif forward_dir == Vector3.RIGHT:
				var turn = BOARDING_TURN_LEFT.instantiate()
				
				
				add_child(turn)
				turn.owner = self
				
				turn.name = "Turn Left"
				
				turn.position = current_pos + Vector3(0,3,0)
				right_turns.append(turn)
		else:
			if forward_dir == Vector3.LEFT:
				var turn = BOARDING_TURN_LEFT.instantiate()
				
				
				add_child(turn)
				right_turns.append(turn)
				turn.owner = self
				
				turn.name = "Turn Left"
				
				turn.position = current_pos + Vector3(0,3,0)
				turn.rotation_degrees.y = -90
			elif forward_dir == Vector3.RIGHT:
				var turn = BOARDING_TURN_RIGHT.instantiate()
				
				
				add_child(turn)
				left_turns.append(turn)
				
				turn.name = "Turn Right"
				
				turn.owner = self
				turn.rotation_degrees.y = 90
				turn.position = current_pos + Vector3(0,3,0)
			forward_dir = Vector3.BACK
			
		current_pos += 10 * prev_dir
		current_pos += 10 * forward_dir
		await get_tree().create_timer(0.11).timeout
		
	await get_tree().process_frame
	await get_tree().process_frame
	#for seg_len in segment_lens:
	
	#print (segment_lens)
	#while current_len < total_path:
		#var end = false
		#var remaining_len = total_path - current_len
		#var next_len:int = rng.randi_range(50, max(50,min(remaining_len, total_path/num_turns)))
		#
		#if remaining_len - 50 <= 0:
			#end = true
			#next_len += remaining_len
			
	for left_turn in left_turns:
		#print(left_turn.name)
		left_turn.connect("player_entered", on_left_turn)
		
	for right_turn in right_turns:
		#print(right_turn.name)
		right_turn.connect("player_entered", on_right_turn)
	
	finished_generation.emit()
	
	cur_loading  = false
	return


func on_left_turn():
	player_left_turn.emit()
	
func on_right_turn():
	player_right_turn.emit()

func body_entered_end_zone(body):
	if body.is_in_group("player"):
		#print("player_entered_end_zone")
		player_finished.emit()
