extends Node

var chosen_luggage : PackedScene = null
var difficulty = 1.0
var current_level : int = 0
var starting_money : float = 100.0
var credits : int = 0

@export var easy_levels : Array[PackedScene] = []
@export var medium_levels : Array[PackedScene] = []
@export var hard_levels : Array[PackedScene] = []

func _ready():
	pass
