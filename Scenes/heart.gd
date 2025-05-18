extends TextureRect

const HEART_E = preload("res://UI Assets/heartE.png")
const HEART_F = preload("res://UI Assets/heartF.png")

func set_full():
	texture = HEART_F
	return
	
func set_empty():
	texture = HEART_E
	return
