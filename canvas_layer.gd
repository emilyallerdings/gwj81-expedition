extends CanvasLayer

signal finished

signal wiped_in
signal wiped_out

var loaded = false

var current_scene = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	layer = 1300
	$ColorRect.material.set_shader_parameter("progress", 0.0)
	pass # Replace with function body.

func transition_to_scene(path:String):
	wipe_in()
	await wiped_in
	if current_scene:
		current_scene.queue_free()
	loaded = false
	ResourceLoader.load_threaded_request(path)
	var load_status = ResourceLoader.THREAD_LOAD_IN_PROGRESS
	while true:
		if load_status == ResourceLoader.THREAD_LOAD_LOADED:
			break
		await get_tree().create_timer(0.01).timeout
		load_status = ResourceLoader.load_threaded_get_status(path)

	var resource = ResourceLoader.load_threaded_get(path)
	var instance = resource.instantiate()
	#
	
	#
	get_tree().root.add_child(instance)
	await get_tree().create_timer(0.1).timeout
	current_scene = instance
	wipe_out()
	await wiped_out

func wipe_in():
	$ColorRect.material.set_shader_parameter("reverse", false)
	$ColorRect.material.set_shader_parameter("progress", 0.0)
	var tween:Tween = create_tween()
	tween.tween_property($ColorRect.material, "shader_parameter/progress", 1.0, .8)
	await tween.finished
	wiped_in.emit()
	return
	
func wipe_out():
	$ColorRect.material.set_shader_parameter("reverse", true)
	var tween:Tween = create_tween()
	tween.tween_property($ColorRect.material, "shader_parameter/progress", 0.0, .8)
	await tween.finished
	wiped_out.emit()
	return
