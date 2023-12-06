extends VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func _process(delta):
#	pass
var tank = load("res://Scenes/TrainEngine.tscn")

#vehicles[0].add_to_track($Track, 100) EXAMPLE
func buyTank():
	var workshop = get_parent().get_parent().get_parent()  # Adjust this to match your scene structure
	print(workshop.name)
	if workshop.money > 10000:
		print(workshop.get_parent().get_parent().get_children())
		if workshop.get_parent().get_parent().get_node("Small Town/WorkshopTrack").wheelOnTrack == false:
			workshop.money  -= 10000
			var tank_instance = tank.instance()
			get_parent().get_parent().get_parent().get_parent().get_node("Train and Tracks").add_child(tank_instance)
			get_parent().get_parent().get_parent().trainList.append(tank_instance)
			tank_instance.add_to_track(workshop.get_parent().get_parent().get_node("Small Town/WorkshopTrack"), 150)
			#tank_instances.append(tank_instance)
