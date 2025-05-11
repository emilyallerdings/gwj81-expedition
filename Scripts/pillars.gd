@tool
extends MultiMeshInstance3D
class_name MultiPillar


# Called when the node enters the scene tree for the first time.
func _ready():
	remesh(50)

func remesh(num):
	multimesh.instance_count = num

	for i in range(num):
		var transform = Transform3D.IDENTITY
		transform.origin = Vector3(0, 3.0, i * 4.0)
		multimesh.set_instance_transform(i, transform)
