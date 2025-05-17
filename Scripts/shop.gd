extends Node3D

signal highlight_item
signal interact_item

@onready var selection_menu_ui = $"Selection Menu UI"
@onready var pointer = $Pointer
@onready var camera = $Camera3D
@onready var item_descriptor = $"Selection Menu UI/Panel/Item Descriptor"
@onready var item_title = $"Selection Menu UI/Item Title"

var select_map = null
var collider = null
var current_interacted_item: StaticBody3D = null

const BOARDING_PASS = preload("res://Scenes/boarding_pass.tscn")

const WHEEL_LUBRICANT = preload("res://Scenes/wheel_lubricant.tscn")
const STICKY_WHEEL = preload("res://Scenes/sticky_wheel.tscn")

var top_shelf_scenes = [BOARDING_PASS]

var bottom_shelf_scenes = [WHEEL_LUBRICANT, STICKY_WHEEL]

var top_shelf_cur = []
var bottom_shelf_cur = []

var selected_item = null

func _ready():
	SoundBus.rolling_suitcase.stop()
	SoundBus.song_3.play()
	
	
	
	select_map = GameManager.map_select_loaded
	select_map.reset()
	select_map.prev_scene = selection_menu_ui
	select_map.visible = false
	
	var dup_bottom_scenes = bottom_shelf_scenes.duplicate()
	dup_bottom_scenes.shuffle()
	for i in range (0,3):
		var new_btm_shelf_item = bottom_shelf_scenes.pop_front()
		if new_btm_shelf_item:
			var inst = new_btm_shelf_item.instantiate()
			bottom_shelf_cur.append(inst)
			inst.position += Vector3(-18, 12, (i-1) * 40)
			$"Shop Items".add_child(inst)
			
	var dup_top_scenes = top_shelf_scenes.duplicate()
	dup_top_scenes.shuffle()
	for i in range (0,3):
		var new_top_shelf_item = dup_top_scenes.pop_front()
		if new_top_shelf_item:
			var inst = new_top_shelf_item.instantiate()
			top_shelf_cur.append(inst)
			inst.position += Vector3(-18, 40, (i-1) * 40)
			$"Shop Items".add_child(inst)

func _process(delta):
	var viewport = get_viewport()
	var mouse_pos = viewport.get_mouse_position()
		
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)

	var direction_to_mouse = (ray_origin + ray_direction * 2000.0) - pointer.global_position

	pointer.target_position = direction_to_mouse.normalized() * 2000.0
	
	if pointer.is_colliding():
		collider = pointer.get_collider()
		if collider is ShopItem:
			highlight_item.emit(collider)

			if Input.is_action_just_pressed("interact"):
				current_interacted_item = collider
				selected_item = collider
				interact_item.emit(collider)
				
			item_descriptor.text = collider.description
			item_title.text = collider.item_title
	else:
		highlight_item.emit(null)
		if selected_item != null:
			item_descriptor.text = selected_item.description
			item_title.text = selected_item.item_title
		if Input.is_action_just_pressed("interact"): # AND NOT BUTTON 
			interact_item.emit(null)
			highlight_item.emit(null)

func _on_next_pressed():
	SoundBus.button.play()
	selection_menu_ui.visible = false
	select_map.visible = true
	select_map.map_select_on = !select_map.map_select_on
	
	selection_menu_ui.visible = false
