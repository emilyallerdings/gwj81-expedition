extends StaticBody3D

class_name ShopItem

signal locked_in

var can_buy_col:Color = Color.WHITE
var cant_buy_col:Color = Color.RED

@export var item_title : String = ""
@export_multiline var description : String = ""
@export var mesh_array : Array[Node] = []
@export_multiline var positive_modifier_description : String = ""
@export_multiline var negative_modifier_description : String = ""

@export var price:int = 0

@export var top_speed_change:float = 0.0
@export var handling_change:float = 0.0
@export var boost_change:float = 0.0
@export var max_hp_change:int = 0
@export var hp_change:int = 0
@export var base_dif_change:int = 0
@export var earnings_increase:float = 0
const PRICE_TAG = preload("res://Scenes/price_tag.tscn")
@export var on_buy:String = ""

var rotation_speed : Vector3 = Vector3(0, 20, 0)
var bob_amplitude : float = .3
var bob_speed : float = 2.0 
var time : float = 0.0
var base_y : float

var bought = false

var selected : bool = false
var is_interacted : bool = false
var outliner : ShaderMaterial = preload("res://Materials/selection_outline.tres")
var selected_outliner : ShaderMaterial = preload("res://Materials/interacted_outline.tres")

var force_cant_buy = false
var price_tag 

func _ready():
	bought = false
	get_tree().get_first_node_in_group("shop").highlight_item.connect(_on_highlight)
	get_tree().get_first_node_in_group("shop").interact_item.connect(_on_interact)
	if has_node("mesh"):
		base_y = $mesh.position.y
	price_tag = PRICE_TAG.instantiate()
	add_child(price_tag)
	price_tag.position.y = -2
	price_tag.position.x = 1
	price_tag.set_price(price)


func _process(delta):
	time += delta
	if has_node("mesh"):
		$mesh.rotation_degrees += rotation_speed * delta
		$mesh.position.y = base_y + sin(time * bob_speed) * bob_amplitude

func _on_highlight(collider: Node):
	selected = (collider == self)
	if not is_interacted:
		_update_outline()

func _on_interact(collider: Node):
	is_interacted = (collider == self)
	_update_outline()

func _update_outline():
	if is_interacted:
		SoundBus.click.play()
		locked_in.emit(true)
		_set_material(selected_outliner)
	elif selected:
		_set_material(outliner)
	else:
		_set_material(null)

func _set_material(material: ShaderMaterial):
	for mesh in mesh_array:
		if mesh:
			mesh.material_overlay = material

func buy():
	if bought:
		return
	GameManager.total_money -= price
	
	GameManager.boost_mod += boost_change
	GameManager.speed_mod += top_speed_change
	GameManager.handling_mod += handling_change
	GameManager.total_health += max_hp_change
	GameManager.health += hp_change
	if GameManager.health > GameManager.total_health:
		GameManager.health = GameManager.total_health
	GameManager.base_diff_mod += base_dif_change
	if on_buy != null && on_buy != "":
		if has_method(on_buy):
			call("on_buy")
		
func disable():
	if has_node("mesh"):
		$mesh.visible = false
	$CollisionShape3D.disabled = true
	bought = true
	price_tag.buy()


func enable():
	$CollisionShape3D.disabled = false
	bought = false
	$mesh.visible = true
	price_tag.set_price(price)	
	
func recheck_prices():
	if can_buy():
		price_tag.set_color(can_buy_col)
	else:
		price_tag.set_color(cant_buy_col)

func set_repair_cant_buy():
	if name == "Repair":
		$mesh.visible = true
		price_tag.buy("FULL HP")

func can_buy():
	return GameManager.total_money >= price && !force_cant_buy
