extends HBoxContainer # or Node if this script is attached to the parent of VBoxContainer

# Your list of items
var trains = []
var sliders = []

func _ready():
	# Clear existing children in the VBoxContainer. This is useful to prevent duplicate additions when the game reloads the scene or this method is called multiple times.
	for child in get_children():
		remove_child(child)
		child.queue_free()  # Properly free the node to prevent memory leaks

	# Call the function to create labels and buttons
	create_options(get_parent().get_parent().get_parent().get_parent().trainList)
	
func _process(delta):
	if sliders.size() > 0:
		for i in sliders.size():
			#print(i)
			sliders[i].value = trains[i].wheelForTracking.distanceMovedInPeriod
			sliders[i].max_value = trains[i].maxDistance			

func create_options(items_list):
	clear_children()
	trains = []
	sliders = []
	trains = items_list
	var i = -1
	for item in items_list:
		i+= 1
		var panel_container = PanelContainer.new()
		panel_container.name = "panel"
		add_child(panel_container)
		var vb = VBoxContainer.new()
		vb.name = "vb"
		vb.rect_min_size.x = 100
		panel_container.add_child(vb)
		
		"""var label = Label.new()
		label.text = item.name
		vb.add_child(label) # Adds the label to the VBoxContainer
		"""
		var le = LineEdit.new()
		le.text = item.name
		vb.add_child(le) # Adds the label to the VBoxContainer
		
		var pb = ProgressBar.new()
		vb.add_child(pb)
		sliders.append(pb)
		
		var button = Button.new()
		button.text = "Select"
		button.name = "Button"
		#button.name = "button_%s" % item # Give the button a unique name based on the item
		vb.add_child(button) # Adds the button to the VBoxContainer
		
		# Connect the button's "pressed" signal to a method with a binding to the item's name
		button.connect("pressed", 
		get_parent().get_parent().get_parent().get_parent(), 
		"selectTrain",
		[i])

func clear_children():
	for child in get_children():
		remove_child(child)
		child.queue_free()  # Properly free the node to prevent memory leaks


func _on_button_pressed(item_name):
	print("Button for %s pressed" % item_name)
	# Here you can define what should happen when the button is pressed
func Highlight(i):
	var x = 0
	for y in get_children():
		if x == i:
			y.get_node("vb/Button").modulate = Color(0, 1, 0)
		else:
			y.get_node("vb/Button").modulate = Color(1, 1, 1)
		x+=1
			
