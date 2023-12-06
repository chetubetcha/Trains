extends Area2D

var is_overlapping_station = false
onready var load_button = get_parent().get_node("LoadButton")

onready var canvas = get_parent().get_node("MiniMenuCanvas")

var v = 0;

func _ready():
	hide_and_deactivate_button()

func _process(delta):
	v = get_parent().get_parent().v
	check_overlap_with_station()

func check_overlap_with_station():
	var overlapping_bodies = self.get_overlapping_areas()
	
	for body in overlapping_bodies:
		#print("reads",body)
		if body.is_in_group("StationArea"):
			if not is_overlapping_station:
				is_overlapping_station = true
				show_and_activate_button() # Show the button when overlapping
			#print("Overlapping Station")
			canvas.set_station(body)
			return

	# If loop completes without finding a station, and the area was previously overlapping
	if is_overlapping_station:
		is_overlapping_station = false
		canvas.null_station()
		hide_and_deactivate_button() # Hide the button when not overlapping

func hide_and_deactivate_button():
	load_button.visible = false
	load_button.disabled = true  # Deactivate the button

func show_and_activate_button():
	load_button.visible = true
	load_button.disabled = false  # Activate the button
