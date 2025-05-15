extends Control

signal countdown_finished

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_countdown():
	$CountdownText.text = "3"
	$CountAnim.play("number_down")
	await get_tree().create_timer(1.0).timeout
	$CountdownText.text = "2"
	$CountAnim.play("number_down")
	await get_tree().create_timer(1.0).timeout
	$CountdownText.text = "1"
	$CountAnim.play("number_down")
	await get_tree().create_timer(1.0).timeout
	
	$CountdownText.text = "GO!"
	$CountAnim.play("go")
	await get_tree().create_timer(0.2).timeout
	countdown_finished.emit()
