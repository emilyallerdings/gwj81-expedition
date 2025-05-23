extends Node3D

@export var title : String = "" 
@export var health : int = 5
@export var top_speed := 10.0
@export var handling := 15.0
@export var boost := 10.0
@export var strafe_speed := 10
@export_multiline var description : String = ""

@export var font : FontFile = preload("res://Materials/NixieOne.ttf")

@export var luggage_collider : CollisionShape3D = null

@export var collision_sound : AudioStreamPlayer = null
