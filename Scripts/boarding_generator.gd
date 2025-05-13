@tool
extends Node3D

@export_category("Generation")
@export var seed:int = 0
@export var total_path:int = 300
@export_tool_button("Randomize Seed", "AudioStreamRandomizer") var rand_seed = randomize_seed
@export_tool_button("Generate", "AudioStreamRandomizer") var gen = generate

const BOARDING_RAMP = preload("res://Scenes/boarding_ramp.tscn")
const BOARDING_TURN_LEFT = preload("res://Scenes/boarding_turn_left.tscn")
const BOARDING_TURN_RIGHT = preload("res://Scenes/boarding_turn_right.tscn")
var cur_loading = false


func randomize_seed():
	seed = (Time.get_ticks_msec() * 98765) % 12345678
	property_list_changed.emit()

func generate():
	if cur_loading:
		return
	cur_loading = true
	await get_tree().process_frame
	var nodes = get_children(true)
	for node in nodes:
		node.call_deferred("queue_free")
		
	await get_tree().process_frame
	
	var rng = RandomNumberGenerator.new()
	rng.seed = seed
	seed(seed)
	
	var num_segs = rng.randi_range(2, total_path/60)
	print("segs: ", num_segs)
	
	
	var segment_lens = []
	segment_lens.resize(num_segs)
	segment_lens.fill(50)
	
	var len_remaining = total_path - 50*num_segs
	
	print("len_rem:",len_remaining, " = ", total_path, " - 50*", num_segs)
	
	var breakpoints = []
	for i in range(0, num_segs-1):
		breakpoints.append(randi_range(0,len_remaining))
	
	breakpoints.sort()
	print("breakpoints:", breakpoints)
	var diff = []
	
	diff.append(breakpoints[0])
	for i in range(1, num_segs-1):
		diff.append(breakpoints[i] - breakpoints[i-1])
	diff.append(len_remaining - breakpoints[breakpoints.size()-1])
	print("diffs: ", diff)
	diff.shuffle()
	for i in range(0, num_segs):
		segment_lens[i] += diff[i]
		segment_lens[i] = snappedi(segment_lens[i], 4)

	var current_pos = Vector3.ZERO
	var forward_dir = Vector3.BACK
	var turn_dir = [Vector3.LEFT, Vector3.RIGHT]
	print(segment_lens)
	#print (turn_dir)

	var counter = 0
	for seg_len in segment_lens:
		counter += 1
		var new_ramp = BOARDING_RAMP.instantiate()
		add_child(new_ramp)
		new_ramp.owner = get_tree().edited_scene_root
		new_ramp.position = current_pos
		new_ramp.length = seg_len
		new_ramp.set_size()
		if forward_dir == Vector3.LEFT:
			new_ramp.rotation.y = deg_to_rad(-90)
		elif forward_dir == Vector3.RIGHT:
			new_ramp.rotation.y = deg_to_rad(90)
		#
		#print("cur: ", current_pos, " += ", seg_len, " * ", forward_dir)
		current_pos += seg_len * forward_dir
		
		if counter == segment_lens.size():
			print("end")
			break
		
		var prev_dir = forward_dir
		
		if forward_dir == Vector3.BACK:
			forward_dir = turn_dir.pick_random()
			if forward_dir == Vector3.LEFT:
				var turn = BOARDING_TURN_RIGHT.instantiate()
				turn.owner = get_tree().edited_scene_root
				add_child(turn)
				turn.position = current_pos + Vector3(0,3,0)
			elif forward_dir == Vector3.RIGHT:
				var turn = BOARDING_TURN_LEFT.instantiate()
				turn.owner = get_tree().edited_scene_root
				add_child(turn)
				turn.position = current_pos + Vector3(0,3,0)
		else:
			if forward_dir == Vector3.LEFT:
				var turn = BOARDING_TURN_LEFT.instantiate()

				add_child(turn)
				turn.owner = get_tree().edited_scene_root
				turn.position = current_pos + Vector3(0,3,0)
				turn.rotation_degrees.y = -90
			elif forward_dir == Vector3.RIGHT:
				var turn = BOARDING_TURN_RIGHT.instantiate()
				
				add_child(turn)
				turn.owner = get_tree().edited_scene_root
				turn.rotation_degrees.y = 90
				turn.position = current_pos + Vector3(0,3,0)
			forward_dir = Vector3.BACK
		current_pos += 10 * prev_dir
		current_pos += 10 * forward_dir
		await get_tree().create_timer(0.1).timeout
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
			

	cur_loading  = false
	return

	
