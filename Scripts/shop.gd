extends Node3D

signal highlight_item
signal interact_item

@onready var selection_menu_ui = $"Selection Menu UI"
@onready var pointer = $Pointer
@onready var camera = $Camera3D
@onready var item_descriptor = $"Selection Menu UI/Panel/Item Descriptor"
@onready var item_title = $"Selection Menu UI/Item Title"
@onready var positive_modifier = $"Selection Menu UI/Panel2/Positive Modifier"
@onready var negative_modifier = $"Selection Menu UI/Panel3/Negative Modifier"

var select_map = null
var collider = null
var current_interacted_item: StaticBody3D = null

const NITRO = preload("res://Scenes/items/nitro.tscn")
const BOARDING_PASS = preload("res://Scenes/items/boarding_pass_new.tscn")

const WHEEL_LUBRICANT = preload("res://Scenes/items/wheel_lube_new.tscn")
const STICKY_WHEEL = preload("res://Scenes/items/sticky_wheel_new.tscn")
const BIKEPUMP = preload("res://Scenes/items/bikepump.tscn")

const PRICE_TAG = preload("res://Scenes/price_tag.tscn")

const REPAIR = preload("res://Scenes/items/repair.tscn")

var top_shelf_scenes = [BOARDING_PASS, NITRO]

var bottom_shelf_scenes = [WHEEL_LUBRICANT, STICKY_WHEEL, BIKEPUMP]

var top_shelf_cur = []
var bottom_shelf_cur = []

var selected_item = null
var repair_inst = null

func _ready():
	
	$"Selection Menu UI/Label".text = "YOUR CASH: " + GameManager.cents_to_str(GameManager.total_money)
	SoundBus.rolling_suitcase.stop()
	SoundBus.song_3.play()
	$"Selection Menu UI/Buy".disabled = true
	
	item_descriptor.text = ""
	item_title.text = ""
	positive_modifier.text = ""
	negative_modifier.text = ""
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
			inst.position += Vector3(6, 20, (i-1) * 40)
			$"Shop Items".add_child(inst)

			
	var dup_top_scenes = top_shelf_scenes.duplicate()
	dup_top_scenes.shuffle()
	for i in range (0,2):
		var new_top_shelf_item = dup_top_scenes.pop_front()
		if new_top_shelf_item:
			var inst = new_top_shelf_item.instantiate()
			top_shelf_cur.append(inst)
			inst.position += Vector3(6, 48, (i-1) * 40 + 20)
			$"Shop Items".add_child(inst)

	var repair = REPAIR.instantiate()
	$"Shop Items".add_child(repair)
	repair.position += Vector3(8, 27, 60)
	repair_inst = repair
	repair_check()
	
	for item in $"Shop Items".get_children():
		item.recheck_prices()
		
func _physics_process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_direction = camera.project_ray_normal(mouse_pos)
	var ray_end = ray_origin + ray_direction * 1000.0  # Ray length

	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	var result = space_state.intersect_ray(query)

	if result:
		var collider = result.collider
		if collider is ShopItem:
			highlight_item.emit(collider)

			if Input.is_action_just_pressed("interact"):
				if collider.can_buy():
					current_interacted_item = collider
					selected_item = collider
					interact_item.emit(collider)
					$"Selection Menu UI/Buy".disabled = false
				else:
					SoundBus.wrong.play()
			set_pos_neg_mod(collider)
			item_descriptor.text = collider.description
			item_title.text = collider.item_title
		else:
			hover_none()
	else:
		hover_none()
		pass

func hover_none():
	highlight_item.emit(null)
		
	if selected_item != null:
		set_pos_neg_mod(selected_item)
		item_descriptor.text = selected_item.description
		item_title.text = selected_item.item_title
	else:
		item_title.text = ""
		item_descriptor.text = ""
		negative_modifier.text = ""
		positive_modifier.text = ""

func set_pos_neg_mod(item):
	negative_modifier.text = ""
	positive_modifier.text = ""
	
	#$"Selection Menu UI/Panel/Item Descriptor2".text = ""
	if item.positive_modifier_description && item.positive_modifier_description != "":
		positive_modifier.text = item.positive_modifier_description
	if item.negative_modifier_description && item.negative_modifier_description != "":
		negative_modifier.text = item.negative_modifier_description



func _on_next_pressed():
	SoundBus.button.play()
	selection_menu_ui.visible = false
	select_map.visible = true
	select_map.map_select_on = !select_map.map_select_on
	
	selection_menu_ui.visible = false


func _on_buy_pressed() -> void:
	SoundBus.buy.play()
	$"Selection Menu UI/Label".text = "YOUR CASH: " + GameManager.cents_to_str(GameManager.total_money)
	if selected_item:
		selected_item.buy()
		if selected_item.name != "Repair":
			selected_item.disable()
			$"Selection Menu UI/Buy".disabled = true
		repair_check()
		selected_item = null
		item_descriptor.text = ""
		item_title.text = ""
		
	for item in $"Shop Items".get_children():
		item.recheck_prices()
	$"Selection Menu UI/Label".text = "YOUR CASH: " + GameManager.cents_to_str(GameManager.total_money)
	pass # Replace with function body.

func repair_check():
	if GameManager.health >= GameManager.total_health:
		GameManager.health = GameManager.total_health
		repair_inst.force_cant_buy = true
		repair_inst.set_repair_cant_buy()
	else:
		repair_inst.enable()
		repair_inst.force_cant_buy = false
