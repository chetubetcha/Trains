extends Node2D

enum BuildState { NONE, BUILDING_FIRST_TRACK, BUILDING_SECOND_TRACK, PLACING_SWITCH }
var build_state = BuildState.NONE
var track_end_position = Vector2()
var first_track
var second_track
var track_switch

var start

var build_switch = false

var line_1 = Line2D.new() # First line for the first track
var line_2 = Line2D.new() # Second line for the second track

var track_scene = preload("res://Scenes/Track.tscn") # Preload the track scene
var track_switch_scene = preload("res://Scenes/TrackSwitch.tscn") # Preload the track switch scene

func _ready():
	build_switch = false
	add_child(line_1) # Add the first line to the scene
	add_child(line_2) # Add the second line to the scen
func _process(delta):
	#if build_state == BuildState.BUILDING_FIRST_TRACK:
	#	line_1.points.append(get_local_mouse_position()) # Update line 1 points as the mouse moves
	#elif build_state == BuildState.BUILDING_SECOND_TRACK:
	#	line_2.points.append(get_local_mouse_position())
	pass

func _input(event):
	if build_switch:
		if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
			match build_state:
				BuildState.NONE:
					build_state = BuildState.BUILDING_FIRST_TRACK
					start_building_track(get_local_mouse_position())
				BuildState.BUILDING_FIRST_TRACK:
					finalize_track()
					build_state = BuildState.BUILDING_SECOND_TRACK
				# Automatically start building the second track
					start_building_track(track_end_position)
				BuildState.BUILDING_SECOND_TRACK:
					finalize_track()
					build_state = BuildState.PLACING_SWITCH
				BuildState.PLACING_SWITCH:
					place_switch(get_local_mouse_position())

# Call this method to start building a track
func start_building_track(start_pos):
	start = start_pos
	if build_state == BuildState.BUILDING_FIRST_TRACK:
		line_1.points = [start_pos] # Start with a single point for line 1
	elif build_state == BuildState.BUILDING_SECOND_TRACK:
		line_2.points = [start_pos]
	var editable_path = Path2D.new()
	add_child(editable_path)
	editable_path.curve.add_point(start_pos)

# Finalizes the track and stores it in a variable
func finalize_track():
	var new_track = track_scene.instance()
	new_track.position = track_end_position
	add_child(new_track)
	if build_state == BuildState.BUILDING_FIRST_TRACK:
		first_track = new_track
	elif build_state == BuildState.BUILDING_SECOND_TRACK:
		second_track = new_track
	# You may want to capture the end position for the next track start
	track_end_position = get_local_mouse_position()
	build_switch = false

# Places the switch at the given position
func place_switch(position):
	track_switch = track_switch_scene.instance()
	track_switch.position = position
	add_child(track_switch)
	# Link the switch to the tracks
	link_tracks_to_switch()
	build_state = BuildState.NONE

func link_tracks_to_switch():
	# Assuming the track switch script has a method to link tracks to it
	track_switch.link_track(first_track, "head", "tail")
	track_switch.link_track(second_track, "head", "tail")
	# Set the correct switch state, direction, or any other properties

# Reset everything if needed
func reset_builder():
	build_state = BuildState.NONE
	# Remove or reset tracks and switch if necessary

# You can connect UI elements or keyboard events to call `reset_builder` to cancel the building process


func _on_Button2_pressed():
	build_switch = true
