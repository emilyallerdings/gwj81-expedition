extends Control

signal countdown_finished

func start_countdown():
	$CountdownText.text = "3"
	$CountAnim.play("number_down")
	await get_tree().create_timer(1.0, false).timeout
	$CountdownText.text = "2"
	$CountAnim.play("number_down")
	await get_tree().create_timer(1.0, false).timeout
	$CountdownText.text = "1"
	$CountAnim.play("number_down")
	await get_tree().create_timer(1.0, false).timeout
	
	$CountdownText.text = "GO!"
	$CountAnim.play("go")
	await get_tree().create_timer(0.2, false).timeout
	countdown_finished.emit()
	

func finish():
	$CountdownText.text = "fin"
	$CountAnim.play("fin")
	#SoundBus.whistle.play()
