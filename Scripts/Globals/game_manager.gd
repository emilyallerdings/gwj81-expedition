extends Node

signal select_luggage

var chosen_luggage : PackedScene = null

func _ready():
	select_luggage.connect(_on_chosen_luggage)


func _on_chosen_luggage(luggage : PackedScene):
	chosen_luggage = luggage
