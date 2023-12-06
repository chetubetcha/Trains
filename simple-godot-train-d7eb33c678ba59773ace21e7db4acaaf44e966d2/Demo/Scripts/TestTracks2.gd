extends Node

export var car_count = 6

onready var train_vehicle_reference = load("res://Scenes/TrainVehicle.tscn")
onready var engine = $TrainEngine
onready var vehicle = $TrainVehicle

func _setup_train():
	engine.connect("train_info", $TestWorld, "update_train_info")
	engine.add_to_track($Tracks/Track, 500)
	vehicle.add_to_track($Tracks/Track, 400)
	

func _on_Timer_timeout():
	_setup_train()
