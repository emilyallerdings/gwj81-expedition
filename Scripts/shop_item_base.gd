extends Node3D

class_name ShopItem

signal locked_in

@export var item_title : String = ""
@export_multiline var description : String = ""
@export var mesh_array : Array[MeshInstance3D] = []
@export var positive_modifier_description : String = ""
@export var negative_modifier_description : String = ""

var rotation_speed : Vector3 = Vector3(0, 20, 0)
var bob_amplitude : float = 1.0
var bob_speed : float = 2.0 
var time : float = 0.0
var base_y : float

var selected : bool = false
var is_interacted : bool = false
var outliner : ShaderMaterial = preload("res://Materials/selection_outline.tres")
var selected_outliner : ShaderMaterial = preload("res://Materials/interacted_outline.tres")

func _ready():
	get_tree().get_first_node_in_group("shop").highlight_item.connect(_on_highlight)
	get_tree().get_first_node_in_group("shop").interact_item.connect(_on_interact)
	base_y = self.position.y

func _process(delta):
	time += delta
	
	self.rotation_degrees += rotation_speed * delta
	self.position.y = base_y + sin(time * bob_speed) * bob_amplitude

func _on_highlight(collider: Node):
	selected = (collider == self)
	if not is_interacted:
		_update_outline()

func _on_interact(collider: Node):
	is_interacted = (collider == self)
	_update_outline()

func _update_outline():
	if is_interacted:
		locked_in.emit(true)
		_set_material(selected_outliner)
	elif selected:
		_set_material(outliner)
	else:
		_set_material(null)

func _set_material(material: ShaderMaterial):
	for mesh in mesh_array:
		mesh.material_overlay = material
