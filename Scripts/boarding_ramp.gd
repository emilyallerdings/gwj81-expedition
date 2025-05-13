@tool
extends Node3D

@export var width := 10.0
@export var length := 200.0

@export_tool_button("Resize", "Callable") var set_size_btn = set_size

@onready var roof: StaticBody3D = $Roof
@onready var roof_mesh: MeshInstance3D = $Roof/RoofMesh


@onready var floor_mesh: MeshInstance3D = $Floor/FloorMesh
@onready var floor: StaticBody3D = $Floor

@onready var side_left: StaticBody3D = $SideLeft
@onready var side_left_mesh: MeshInstance3D = $SideLeft/SideLeftMesh
@onready var side_left_coll: CollisionShape3D = $SideLeft/SideLeftColl


@onready var side_right: StaticBody3D = $SideRight
@onready var side_right_mesh: MeshInstance3D = $SideRight/SideRightMesh
@onready var side_right_coll: CollisionShape3D = $SideRight/SideRightColl


@onready var pillars_left: MultiPillar = $PillarsLeft
@onready var pillars_right: MultiPillar = $PillarsRight

@onready var window_left: MeshInstance3D = $WindowLeft
@onready var window_right: MeshInstance3D = $WindowRight


func set_size():
	self.position.y = 3.0
	floor_mesh.mesh.size.z = length
	floor_mesh.mesh.size.x = width
	floor.position.z = (length / 2.0)
	
	roof_mesh.mesh.size.z = length
	roof_mesh.mesh.size.x = width
	roof.position.z = (length / 2.0)

	side_left_mesh.mesh.size.z = length
	side_left_coll.shape.size.z = length
	side_left.position.z = (length / 2.0)
	side_left.position.x = width/2.0
	
	side_right_mesh.mesh.size.z = length
	side_right_coll.shape.size.z = length
	side_right.position.z = (length / 2.0)
	side_right.position.x = -width/2.0
	
	window_left.mesh.size.z = length
	window_left.position.z = (length / 2.0)
	window_left.position.x = width/2.0	
	
	window_right.mesh.size.z = length
	window_right.position.z = (length / 2.0)
	window_right.position.x = -width/2.0
	
	pillars_left.position.x = width/2.0
	pillars_right.position.x = -width/2.0
	
	pillars_left.remesh(int(ceil(length/4)) + 1)
	pillars_right.remesh(int(ceil(length/4)) + 1)
	
	
	
