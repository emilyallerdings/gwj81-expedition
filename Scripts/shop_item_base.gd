extends Node3D

class_name ShopItem

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
var outliner : ShaderMaterial = preload("res://Materials/selection_outline.tres")

func _ready():
	get_tree().get_first_node_in_group("shop").highlight_item.connect(set_outline_overlay)
	base_y = self.position.y

func _process(delta):
	_update_outline()
	time += delta
	
	self.rotation_degrees += rotation_speed * delta
	self.position.y = base_y + sin(time * bob_speed) * bob_amplitude

func set_outline_overlay(collider):
	selected = (collider == self)
	#for child in get_children():
		#if child is MeshInstance3D:
			#child.material_overlay = outliner

func _update_outline():
	if selected:
		for meshes in mesh_array:
			meshes.material_overlay = outliner
	else:
		for meshes in mesh_array:
			meshes.material_overlay = null
