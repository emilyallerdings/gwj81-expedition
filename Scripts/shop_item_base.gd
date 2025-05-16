extends Node3D

var rotation_speed : Vector3 = Vector3(0, 20, 0)

func _process(delta):
	self.rotation_degrees += rotation_speed * delta
