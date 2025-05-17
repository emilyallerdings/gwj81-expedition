extends Node3D

signal highlight_item

@onready var selection_menu_ui = $"Selection Menu UI"
@onready var pointer = $Pointer
@onready var camera = $Camera3D

@onready var item_descriptor = $"Selection Menu UI/Panel/Item Descriptor"
@onready var item_title = $"Selection Menu UI/Item Title"

var select_map = null
var collider = null

func _ready():
	SoundBus.rolling_suitcase.stop()
	SoundBus.song_3.play()
	
	select_map = GameManager.map_select_loaded
	select_map.reset()
	select_map.prev_scene = selection_menu_ui
	select_map.visible = false

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
			item_descriptor.text = collider.description
			item_title.text = collider.item_title
	
	pointer.enabled = !select_map.map_select_on
	#print(select_map.map_select_on)
	#print(pointer.enabled)

func _on_next_pressed():
	SoundBus.button.play()
	selection_menu_ui.visible = false
	select_map.visible = true
	select_map.map_select_on = !select_map.map_select_on
	
	selection_menu_ui.visible = false
