extends Node2D

var is_building_path = false
var is_building_path1 = false
var is_building_path2 = false
var is_building_switch = false
var track_buildable = false
var switch_buildable = false
var editable_path : Path2D
var path_line : Line2D # Reference to your Line2D node
var editable_path2 : Path2D
var path_line2 : Line2D
var track_scene = preload("res://Scenes/Track.tscn") # Preload the track scene
var track_switch_scene = preload("res://Scenes/TrackSwitch.tscn")

var switch_head_point
var switch_tail1
var curve1
var switch_tail2
var curve2
var switch_button_loc

var track_stack = []

var length1
var length2

func _ready():
	# Add this inside the _ready function:
	#var build_track_button = $PathToYourButton
	#build_track_button.connect("pressed", self, "_on_BuildTrackButton_pressed")
	editable_path = $EditablePath
	path_line = $Line2D # Adjust the path to match your scene
	editable_path2 = $EditablePath2
	path_line2 = $Line2D2
	path_line = create_new_path_line()
	path_line2 = create_new_path_line()

func _on_BuildTrackButton_pressed():
	track_buildable = true

func _process(delta):
	if track_buildable or switch_buildable:
		pass
		#print(str(get_path_length(path_line)),"-",str(get_path_length(path_line2)))

func _input(event):
	if track_buildable:
		if event is InputEventMouseButton:
			var local_pos = get_local_mouse_position()

			if event.button_index == BUTTON_LEFT and event.pressed:
				if not is_building_path:
				# First left click, start building the path
					is_building_path = true
					editable_path.curve.clear_points()
					editable_path.curve.add_point(local_pos)
					path_line.points = [local_pos, local_pos] # Initialize with the starting point twice
				else:
				# Second left click, finish the path and replace with track scene
					editable_path.curve.add_point(local_pos)
					is_building_path = false
					finalize_track(editable_path.curve)
			elif event.button_index == BUTTON_RIGHT and event.pressed and is_building_path:
			# Right click, add a point to the path
				editable_path.curve.add_point(local_pos)
				path_line.points[path_line.points.size() - 1] = local_pos # Update the last point
				path_line.add_point(local_pos) # Add a new point that follows the mouse
				path_line.update()
			#pass

		elif event is InputEventMouseMotion and is_building_path:
			# Update the temporary last point of the line to follow the mouse position
			var mouse_pos = get_local_mouse_position()
			path_line.points[path_line.points.size() - 1] = mouse_pos
			# This function returns the total length of the current Line2D path.
			get_path_length(path_line)

		if event is InputEventKey:
			if event.pressed and not event.echo and event.scancode == KEY_Z and event.control:
				undo_last_track()
			if event.pressed and not event.echo:
				if event.scancode == KEY_ESCAPE:
					cancel_process()
				
	elif switch_buildable:
		if event is InputEventMouseButton:
			var local_pos = get_local_mouse_position()
			if event.button_index == BUTTON_LEFT and event.pressed:
				if not is_building_path1 and not is_building_path2 and not is_building_switch:  
					# First left click, start building the path
					print("first l click")
					is_building_path1 = true
					is_building_switch = false
					editable_path.curve.clear_points()
					switch_head_point = local_pos
					editable_path.curve.add_point(local_pos)
					path_line.points = [local_pos, local_pos] # Initialize with the starting point twice
				elif is_building_path1 and not is_building_path2 and not is_building_switch:
					print("second l click")
					editable_path.curve.add_point(local_pos)
					switch_tail1 = local_pos
					curve1 = editable_path.curve
					editable_path2.curve.clear_points()
					editable_path2.curve.add_point(switch_head_point)
					path_line2.points = [switch_head_point, switch_head_point]
					is_building_path1 = false
					is_building_path2 = true
					is_building_switch = false
					#next_step(editable_path.curve)
				elif not is_building_path1 and is_building_path2 and not is_building_switch:
					print("third l click")
					editable_path2.curve.add_point(local_pos)
					# Second left click, finish the path and replace with track scene
					is_building_path1 = false
					is_building_path2 = false
					is_building_switch = true
					curve2 = editable_path2.curve
					next_step(editable_path.curve,editable_path2.curve)
					#finalize_track(editable_path.curve)  ##NEED NEW FINALIZE FUNCTION
				else:
					print("fourth l click")
					#BUILD SWITCH IN HERE, THEN FINALIZE IT
					switch_button_loc = local_pos
					#switch_button_loc.points = [local, local_pos]
					finalize_switch()
			elif event.button_index == BUTTON_RIGHT and event.pressed and is_building_path1:
			# Right click, add a point to the 
				print("R click path1")
				editable_path.curve.add_point(local_pos)
				path_line.points[path_line.points.size() - 1] = local_pos # Update the last point
				path_line.add_point(local_pos) # Add a new point that follows the mouse
				path_line.update()
			elif event.button_index == BUTTON_RIGHT and event.pressed and is_building_path2:
				# Right click, add a point to the path
				print("R Click path2")
				editable_path2.curve.add_point(local_pos)
				path_line2.points[path_line2.points.size() - 1] = local_pos # Update the last point
				path_line2.add_point(local_pos) # Add a new point that follows the mouse
				path_line2.update()
		elif event is InputEventMouseMotion and is_building_path1:
			# Update the temporary last point of the line to follow the mouse position
			var mouse_pos = get_local_mouse_position()
			path_line.points[path_line.points.size() - 1] = mouse_pos
		elif event is InputEventMouseMotion and is_building_path1:
			# Update the temporary last point of the line to follow the mouse position
			var mouse_pos = get_local_mouse_position()
			path_line.points[path_line.points.size() - 1] = mouse_pos
		elif event is InputEventMouseMotion and is_building_path2:
			# Update the temporary last point of the line to follow the mouse position
			var mouse_pos = get_local_mouse_position()
			path_line2.points[path_line2.points.size() - 1] = mouse_pos
			
		if event is InputEventKey:
			if event.pressed and not event.echo and event.scancode == KEY_Z and event.control:
				undo_last_track()
			if event.pressed and not event.echo:
				if event.scancode == KEY_ESCAPE:
					cancel_process()

func next_step(curve: Curve2D,curve2: Curve2D):
	if is_building_path1:
		#WE MUST SAVE THE POINTS TO BUILD THE ENTIRE SWITCH AT ONCE AT THE END
		#curve1 = curve
		is_building_path1 = false
		is_building_path2 = true
	if is_building_path2:
		#curve2 = curve
		is_building_path1 = false
		is_building_path2 = false
func finalize_switch():
	if !checkCost():
		return
	var new_switch = track_switch_scene.instance() as TrackSwitch
	var head1 = new_switch.get_node("LeftTrack").get_node("HeadPoint")
	var tail1 = new_switch.get_node("LeftTrack").get_node("TailPoint")
	var head2 = new_switch.get_node("RightTrack").get_node("HeadPoint")
	var tail2 = new_switch.get_node("RightTrack").get_node("TailPoint")
	var button = new_switch.get_node("Button")
	head1.position = path_line.points[0]
	head2.position = path_line2.points[0]
	tail1.position = path_line.points[path_line.points.size() - 1]
	tail2.position = path_line2.points[path_line2.points.size() - 1]
	button.rect_position = switch_button_loc#.position
	
	new_switch.get_node("LeftTrack").curve = curve1
	new_switch.get_node("RightTrack").curve = curve2
	
	print(editable_path.curve,editable_path2.curve)
	print(curve1,curve2)
	
	get_parent().add_child(new_switch)
	track_stack.append(new_switch)
	editable_path.queue_free()
	editable_path2.queue_free()
	
	var new_editable_path = Path2D.new()
	get_parent().add_child(new_editable_path)
	editable_path = new_editable_path
	var new_editable_path2 = Path2D.new()
	get_parent().add_child(new_editable_path2)
	editable_path2 = new_editable_path2
	path_line.points = []
	path_line2.points = []
	#path_line = new_editable_path.get_node("Line2D")  # Make sure the Line2D node is a child of the new Path2D
	path_line = create_new_path_line()
	is_building_path = false
	track_buildable = false
	path_line2 = create_new_path_line()
	is_building_path1 = false
	is_building_path2 = false
	switch_buildable = false
	is_building_switch = false

func finalize_track(curve: Curve2D):
	if !checkCost():
		return
	var new_track = track_scene.instance() as Track  # Cast to your custom Track type
	var head = new_track.get_node("HeadPoint")
	head.position = path_line.points[0]
	var tail = new_track.get_node("TailPoint")
	tail.position = path_line.points[path_line.points.size() - 1]
	if not new_track:
		push_error("Failed to instance the track scene.")
		return

	new_track.curve = curve
	get_parent().add_child(new_track)
	track_stack.append(new_track)
	editable_path.queue_free()

	# Re-instantiate editable_path for a new track
	var new_editable_path = Path2D.new()
	get_parent().add_child(new_editable_path)
	editable_path = new_editable_path
	path_line.points = []
	#path_line = new_editable_path.get_node("Line2D")  # Make sure the Line2D node is a child of the new Path2D
	path_line = create_new_path_line()
	is_building_path = false
	track_buildable = false
	
func create_new_path_line() -> Line2D:
	# Create a new Line2D node or assign an existing one
	var new_path_line = Line2D.new()
	new_path_line.width = 20
	var line_texture = load("res://Demo/Assets/track.png")
	new_path_line.texture = line_texture
	#new_path_line.texture_mode = Line2D.TEXTURE_MODE_TILE 
	new_path_line.texture_mode = Line2D.LINE_TEXTURE_TILE
	new_path_line.z_index = 1
	add_child(new_path_line)  # Adds the new Line2D to the scene tree
	return new_path_line

func _on_BuildingTrackButton_pressed():
	_on_BuildTrackButton_pressed()

func undo_last_track():
	if track_stack.size() > 0:
		var last_track = track_stack.pop_back() # Remove the last track from the stack
		last_track.queue_free() # Remove it from the scene


func _on_Button2_pressed():
	switch_buildable = true
	
	# This function returns the total length of the current Line2D path.
func get_path_length(line) -> float:
	var length: float = 0.0
	for i in range(line.points.size() - 1):
		length += line.points[i].distance_to(line.points[i + 1])
	return length
func total_length():
	var x = get_path_length(path_line)
	var y = get_path_length(path_line2)
	var z = x + y
	return z

func cancel_process():
	# Reset the building flags
	is_building_path = false
	is_building_path1 = false
	is_building_path2 = false
	is_building_switch = false
	
	editable_path.curve.clear_points()
	editable_path2.curve.clear_points()
	
	path_line.points = []
	path_line.update()
	path_line2.points = []
	path_line2.update()
	
	# Clear or reset other game states as needed
	track_buildable = false
	switch_buildable = false
	track_stack = [] # Clear any stack of tracks if necessary
	
	# Add any other cleanup code here
	
func checkCost():
	if total_length() > get_parent().get_node("UI").money:
		return false
	else:
		get_parent().get_node("UI").money -= total_length()
		return true

#NOT USED CURRENTLY
func check_collisions(points: PoolVector2Array) -> bool:
	for zone in get_tree().get_nodes_in_group("impassable_zones"):
		if zone is CollisionShape2D:
			var collision_shape = zone as CollisionShape2D
			
			for i in range(points.size() - 1):
				var line_start = points[i]
				var line_end = points[i + 1]
				
				if collision_shape.intersect_shape(line_start, line_end):
					return true

	return false
func lines_intersect(a_start: Vector2, a_end: Vector2, b_start: Vector2, b_end: Vector2) -> bool:
	var denom = (b_end.y - b_start.y) * (a_end.x - a_start.x) - (b_end.x - b_start.x) * (a_end.y - a_start.y)

	if denom == 0:
		return false

	var ua = ((b_end.x - b_start.x) * (a_start.y - b_start.y) - (b_end.y - b_start.y) * (a_start.x - b_start.x)) / denom
	var ub = ((a_end.x - a_start.x) * (a_start.y - b_start.y) - (a_end.y - a_start.y) * (a_start.x - b_start.x)) / denom

	return ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1



