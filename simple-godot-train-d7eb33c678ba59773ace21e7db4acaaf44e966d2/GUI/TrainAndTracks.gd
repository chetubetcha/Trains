extends Node

export var car_count = 6

#onready var train_vehicle_reference = load("res://Scenes/TrainVehicle.tscn")
onready var engine = $TrainEngine

onready var engines = []
onready var vehicles = []
#onready var vehicle = $TrainVehicle

func _ready():
	pass
	#engines.append($TrainEngine)
	#engines.append($TrainEngine2)
	#vehicles.append($TrainVehicle)
	#vehicles.append($TrainVehicle2)

func _setup_train():
	pass
	#engine.connect("train_info", $TestWorld, "update_train_info")
	
	#PUT IN FOR LOOP
	#engines[0].add_to_track($Track, 200)
	#get_parent().get_node("UI").trainList.append(engines[0])
	#engines[1].add_to_track($Track2, 150)
	#get_parent().get_node("UI").trainList.append(engines[1])
	
	#vehicles[0].add_to_track($Track, 100)
	#vehicles[1].add_to_track($Track3, 100)
	
	#vehicle.add_to_track($Tracks/Track, 400)

func _on_Timer_timeout():
	_setup_train()
