extends Control
const MENU_TESTING = "res://Scenes/main_menu.tscn"

var load_status = ResourceLoader.THREAD_LOAD_IN_PROGRESS

@export var to_preload:Array[String]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.play("gif")
	var to_delete = []
	for obj in to_preload:
		
		var load_status_sub = ResourceLoader.THREAD_LOAD_IN_PROGRESS
		var path = "res://Scenes/" + obj + ".tscn"
		print("loading: " + path)
		ResourceLoader.load_threaded_request(path)
		while true:
			if load_status_sub == ResourceLoader.THREAD_LOAD_LOADED:
				break
			if load_status_sub == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				print("in progress...")
			if load_status_sub == ResourceLoader.THREAD_LOAD_FAILED:
				print("load failed")
			await get_tree().create_timer(0.01).timeout
			load_status_sub = ResourceLoader.load_threaded_get_status(path)
			
		var res = ResourceLoader.load_threaded_get(path)
		var inst = res.instantiate()
		to_delete.append(inst)
	
	for obj in to_delete:
		obj.queue_free()
	await get_tree().create_timer(0.05).timeout
	
	ResourceLoader.load_threaded_request(MENU_TESTING)
	while true:
		if load_status == ResourceLoader.THREAD_LOAD_LOADED:
			break
		await get_tree().create_timer(0.01).timeout
		load_status = ResourceLoader.load_threaded_get_status(MENU_TESTING)
		
	var resource = ResourceLoader.load_threaded_get(MENU_TESTING)
	var main_menu = resource.instantiate()
	get_tree().root.add_child(main_menu)
	
	await get_tree().create_timer(0.1).timeout
	self.visible = false

#func _process(delta: float) -> void:
	#$TextureRect.material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
