@tool
extends MultiMeshInstance3D
class_name MultiPillar

const MULTIMESH_MESH = preload("res://Scenes/multimesh_mesh.tres")
func remesh(num):
	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	await get_tree().process_frame
	multimesh.mesh = MULTIMESH_MESH
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().create_timer(0.05)
	multimesh.instance_count = num
	
	await get_tree().create_timer(0.05)
	await get_tree().process_frame
	await get_tree().process_frame

	for i in num:
		var transform = Transform3D(Basis().scaled(Vector3(1, 1, 1)), Vector3(0, 3.0, i * 4.0))
		multimesh.set_instance_transform(i, transform)
