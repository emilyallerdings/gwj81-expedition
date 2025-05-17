@tool
extends MultiMeshInstance3D
class_name MultiPillar


func remesh(num):
	await get_tree().process_frame
	await get_tree().process_frame
	multimesh.instance_count = num
	await get_tree().process_frame
	await get_tree().process_frame
	for i in range(num):
		var transform = Transform3D.IDENTITY
		transform.origin = Vector3(0, 3.0, i * 4.0)
		multimesh.set_instance_transform(i, transform)
