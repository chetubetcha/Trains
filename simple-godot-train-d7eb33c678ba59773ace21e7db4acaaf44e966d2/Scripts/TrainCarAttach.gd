extends Node2D

onready var train_vehicle: TrainVehicle = get_parent()
  # Adjust the path if the node is nested differently

onready var attach_front = $AttachFront
onready var attach_back = $AttachBack
onready var detach_front = $DetachFront
onready var detach_back = $DetachBack

# These Area2D nodes should be children or accessible from this node
onready var front_area = $FrontCollision
onready var back_area = $BackCollision

var last_position = Vector2()
var check_interval = 0.5
var move_threshold = 5.0

var attached_front = false
var attached_back = false

func _ready():
	hide_all_buttons()
	set_process(false)
	
	# Connect button signals
	attach_front.connect("pressed", self, "_on_AttachFront_pressed")
	attach_back.connect("pressed", self, "_on_AttachBack_pressed")
	detach_front.connect("pressed", self, "_on_DetachFront_pressed")
	detach_back.connect("pressed", self, "_on_DetachBack_pressed")


	# Connect area signals
	front_area.connect("area_entered", self, "_on_FrontArea_entered")
	front_area.connect("area_exited", self, "_on_FrontArea_exited")
	back_area.connect("area_entered", self, "_on_BackArea_entered")
	back_area.connect("area_exited", self, "_on_BackArea_exited")
	
	yield(get_tree().create_timer(check_interval), "timeout")
	set_process(true)

func _process(delta):
	if global_position.distance_to(last_position) < move_threshold:
		update_buttons()
	last_position = global_position

func hide_all_buttons():
	attach_front.hide()
	attach_front.disabled = true
	
	attach_back.hide()
	attach_back.disabled = true
	
	detach_front.hide()
	detach_front.disabled = true
	
	detach_back.hide()
	detach_back.disabled = true


func update_buttons():
	hide_all_buttons()
	
	var is_stationary = train_vehicle.get_velocity() < 0.05  # Some small threshold, not exactly 0 due to possible float inaccuracies

	if train_vehicle.is_lead_vehicle:
		return
	#print(train_vehicle.get_velocity())
	if is_stationary:
		if attached_front:
			detach_front.show()
			detach_front.disabled = false
		elif front_area.get_overlapping_areas().size() > 0:  # Check for a collision at the front
			var overlapping_areas = front_area.get_overlapping_areas()
			for area in overlapping_areas:
				#print("Front Area - ",area,self)
				#print("Front Area- ",area.get_parent(),self.get_parent())
				#print("Front Area- ",area.get_parent().get_parent(),self.get_parent().get_parent())
				if area.get_parent().get_parent() is TrainVehicle && area.get_parent().get_parent() != self.get_parent():
					attach_front.show()
					#print("Can attach front")
					attach_front.disabled = false
		if attached_back:
			detach_back.show()
			detach_back.disabled = false
		elif back_area.get_overlapping_areas().size() > 0:  # Check for a collision at the back
			var overlapping_areas = back_area.get_overlapping_areas()
			for area in overlapping_areas:
				#print(area.get_parent().get_parent(),self.get_parent().get_parent())
				if area.get_parent().get_parent() is TrainVehicle && area.get_parent().get_parent() != self.get_parent():
					attach_back.show()
					#print("Can attach back")
					#print("::",area.get_parent().get_parent())
					attach_back.disabled = false

	
# Button callback functions
func _on_AttachFront_pressed():
	print("Attaching to Front")
	var overlapping_areas = front_area.get_overlapping_areas()
	for area in overlapping_areas:
		print("2")
		if area.get_parent().get_parent() is TrainVehicle and area.get_parent().get_parent() != self.get_parent():  # Check if the overlapping area is a TrainVehicle instance
			print("3")
			area.get_parent().get_parent().set_follower_car(self.get_parent(), true)  # Call the function on the colliding TrainVehicle instance
			attached_front = true
			update_buttons()
			break

func _on_AttachBack_pressed():
	print("Attaching to Back")
	var overlapping_areas = back_area.get_overlapping_areas()
	for area in overlapping_areas:
		if area.get_parent().get_parent() is TrainVehicle and area.get_parent().get_parent() != self.get_parent():  # Check if the overlapping area is a TrainVehicle instance
			area.get_parent().get_parent().set_follower_car(self.get_parent(), false)  # Call the function on the colliding TrainVehicle instance
			attached_back = true
			update_buttons()
			break



func _on_DetachFront_pressed():
	get_parent().front_attached_car.remove_follower_car(self.get_parent())
	attached_front = false  # Implement logic here for detaching at the front
	update_buttons()

func _on_DetachBack_pressed():
	get_parent().back_attached_car.remove_follower_car(self.get_parent())
	attached_back = false  # Implement logic here for detaching at the back
	update_buttons()

# Area callbacks
func _on_FrontArea_entered(area):
	# You'd typically check here if the area is indeed the engine 
	# and not some other object. For simplicity, we'll assume it's the engine.
	#print("COLLIDED!")
	if not attached_front:
		attach_front.show()
		attach_front.disabled = false

func _on_FrontArea_exited(area):
	#print("Left COLLISION!")
	attach_front.hide()
	attach_front.disabled = true

func _on_BackArea_entered(area):
	#print("COLLIDED!")
	if not attached_back:
		attach_back.show()
		attach_back.disabled = false

func _on_BackArea_exited(area):
	#print("Left COLLISION!")
	attach_back.hide()
	attach_back.disabled = true
	

