@tool
extends MultiMeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var num_instances = 50
	multimesh.instance_count = num_instances
	
	for i in range(num_instances):
		var transform = Transform3D.IDENTITY
		transform.origin = Vector3(0, 3.0, i * 4.0)
		multimesh.set_instance_transform(i, transform)
