# Sits on top of two TrainWheels to move along a Track
class_name TrainVehicle
extends Node2D

enum VehicleType {
	NONE,      # Used for engines or any other non-specific types
	PASSENGER,
	LUXURY_PASSENGER,
	MAIL_TRUCK,
	FLATBED_TRUCK,
	VAN,
	SEVEN_PLANK_TRUCK,
	TANKER,
	BOXCAR,
	CATTLE_TRUCK,
	REFRIGERATED_CAR,
	CABOOSE
}
export(VehicleType) var vehicle_type = VehicleType.NONE

var v: float = 0.0
var vm: float = 0.0


signal towed_mass_changed

export var is_lead_vehicle := false

export var wheel_distance = 58
export var follow_distance = 26
export var mass = 10

export var capacity = 10


#var held_cargo = 0

var held_cargo = {}
#[{"type": CargoType.COAL, "amount": 50, "origin": "Station A"}, {"type": CargoType.OIL, "amount": 30, "origin": "Station B"}]

var held_amount = 0


var towed_mass = 0
var total_mass = mass

onready var front_wheel = $RailFollower
onready var back_wheel = $RailFollower2
onready var body = $Body


var engine_instance = null
var leader_vehicle: TrainVehicle = null
var follower: TrainVehicle = null
var front_attached_car: TrainVehicle = null  # This stores the car attached to the front FOLLOWING THIS CAR I BELEIVE
var back_attached_car: TrainVehicle = null

var follower_front_attached_car: TrainVehicle = null  # This stores the car attached to the front
var follower_back_attached_car: TrainVehicle = null
onready var area_child = $Body/StationConnector
onready var load_button = $Body/LoadButton

var PUSHED_CAR: TrainVehicle = null
var wheelForTracking

func _ready():
	front_wheel.connect("moved", back_wheel, "move_as_follower")

func _process(delta):
	if is_lead_vehicle:
		deactivate_children()
		var train_list = get_all_vehicles_in_train()
		#set_and_propagate_velocity(velocity) #done in engine now
		#print(train_list)
	global_position = lerp(global_position, front_wheel.global_position, 0.8)
	body.look_at(back_wheel.global_position)
	
"""func add_cargo(selected_cargo_enum, amount_to_load):
	held_cargo = selected_cargo_enum
	held_amount+= amount_to_load
	print("held cargo: ",held_cargo)
	print("held amount: ",held_amount)"""
func add_cargo(cargo_type, amount, station):
	if cargo_type in held_cargo:
		# Check if the cargo from this source already exists
		var found = false
		for cargo in held_cargo[cargo_type]:
			if cargo["source"] == station:
				cargo["amount"] += amount
				found = true
				break
		
		# If this source was not found, add a new entry
		if not found:
			held_cargo[cargo_type].append({"amount": amount, "source": station})
	else:
		held_cargo[cargo_type] = [{"amount": amount, "source": station}]
	held_amount += amount
	print("Held Cargo: ",held_cargo)


func deduct_cargo(selected_cargo_enum, amount_to_load):
	held_amount-= amount_to_load
	if held_amount == 0:
		held_cargo = null
	else:
		held_cargo = selected_cargo_enum
	print("held cargo: ",held_cargo)
	print("held amount: ",held_amount)
	
func get_all_vehicles_in_train():
	var vehicles = [self]  # Start with the engine itself.
	var current_car = self.follower  # Start with the first follower of the engine
	
	while current_car:
		vehicles.append(current_car)  # Append the follower to the list
		current_car = current_car.follower  # Move to the next follower

	return vehicles

# Place this vehicle (and all of its wheels) on the track
func add_to_track(track: Path2D, offset = 1):
	front_wheel.set_track(track)
	back_wheel.set_track(track)
	front_wheel.offset = offset
	back_wheel.follow(front_wheel, wheel_distance)
	global_position = front_wheel.global_position

# Link another TrainVehicle to follow this one
func set_follower_car(car, attach_to_front=false):
	
	var overlapping_bodies = $Body/FrontCollision.get_overlapping_areas()
	var back_overlapping_bodies = $Body/BackCollision.get_overlapping_areas()
	car.front_wheel.disconnect("moved", self, "move_as_follower")
	car.back_wheel.disconnect("moved", self, "move_as_follower")
	var is_front_overlap = false
	var is_back_overlap = false
	for body in overlapping_bodies:
		if body.get_parent().get_parent() == car:
			follower_front_attached_car = car
			is_front_overlap = true;
			follower_back_attached_car = null
			break  
	for body in back_overlapping_bodies:
		if body.get_parent().get_parent() == car:
			is_back_overlap = true
			follower_back_attached_car = car
			follower_front_attached_car = null
			break  
	
	if attach_to_front:
		print("attaching to front")
		# Attach to front of the main car
		car.front_attached_car = self
		if is_back_overlap:
			# It's front-back
			print("front-back")
			car.front_wheel.follow(back_wheel, follow_distance)
			back_wheel.connect("moved", car.front_wheel, "move_as_follower")
		elif is_front_overlap:
			# It's front-front
			print("front-front")
			car.front_wheel.follow(front_wheel, follow_distance) #originally negative
			front_wheel.connect("moved", car.front_wheel, "move_as_follower")
	else:
		print("attaching to back")
		# Attach to back of the main car
		car.back_attached_car = self
		if is_back_overlap:
			# It's back-back
			print("back-back")
			car.back_wheel.follow(back_wheel, follow_distance)
			back_wheel.connect("moved", car.back_wheel, "move_as_follower")
		elif is_front_overlap:
			# It's back-front
			print("back-front")
			car.back_wheel.follow(front_wheel, -follow_distance)
			front_wheel.connect("moved", car.back_wheel, "move_as_follower")
	
	# Other connections and mass updates
	car.connect("towed_mass_changed", self, "change_towed_mass")
	if is_lead_vehicle:
		addToTrain(engine_instance.fullTrain)
		engine_instance.update_total_mass()
		
# Disconnect this car's signals from its followers
func remove_follower_car(car):
	if follower_front_attached_car == car:
		front_wheel.disconnect("moved", car.back_wheel, "move_as_follower")
		follower_front_attached_car = null
	elif follower_back_attached_car == car:
		back_wheel.disconnect("moved", car.front_wheel, "move_as_follower")
		follower_back_attached_car = null
	else:
		print("Error: Car is not attached!")
		return
	print("Car should be disconnecting")
	car.disconnect("towed_mass_changed", self, "change_towed_mass")
	car.front_attached_car = null
	car.back_attached_car = null
	if is_lead_vehicle:
		engine_instance.update_total_mass()
	#change_towed_mass(-car.total_mass)

	
func is_front_connected():
	return front_attached_car != null

func is_back_connected():
	return back_attached_car != null

# Share the knowledge of the new total mass
func change_towed_mass(mass_delta, propagate_forward = false):
	towed_mass += mass_delta
	total_mass = mass + towed_mass
	emit_signal("towed_mass_changed", mass_delta, self)

	# Propagate changes only towards the back
	if follower != null:
		follower.change_towed_mass(mass_delta)


func _on_RailFollower_track_changed():
	add_to_track(front_wheel.get_parent(), front_wheel.offset)
	
func set_and_propagate_velocity(new_velocity: float, new_vel_multiplier):
	v = new_velocity
	vm = new_vel_multiplier
	
	if follower_front_attached_car:
		follower_front_attached_car.set_and_propagate_velocity(new_velocity,vm)
	
	if follower_back_attached_car:
		follower_back_attached_car.set_and_propagate_velocity(new_velocity,vm)
func get_velocity():
	return v
	
func activate_children():
	area_child.monitoring = true
	area_child.monitorable = true
	load_button.disabled = false
	load_button.show()

func deactivate_children():
	area_child.monitoring = false
	area_child.monitorable = false
	load_button.disabled = true
	load_button.hide()

var is_moving_forward = true  # As an example, adjust based on your logic

func _on_FrontBumper_body_entered(body): ####ADD FUTURE LOGIC:::: Track terminal Bumpers to stop the train
	print("TOUCHING something")
	if body.is_in_group("TrainBumper"):
		print("TOUCHING BUMPER")
		if body.get_parent().get_parent() == front_attached_car or body.get_parent().get_parent() == follower_back_attached_car or body.get_parent().get_parent() == follower_front_attached_car or body.get_parent().get_parent() == back_attached_car:
			return
		#handle_push(body.get_parent().get_parent())

func _on_FrontBumper_body_exited(body):
	pass # Replace with function body.

func _on_BackBumper_body_entered(body):
	if body.is_in_group("TrainBumper"):
		# Handle the logic
		pass

func _on_BackBumper_body_exited(body):
	pass # Replace with function body.

func push_car(direction):
	front_wheel.move(v*vm)

func assignWheel(x):
	if wheelForTracking == null:
		wheelForTracking = x

func addToTrain(x):
	print("Called")
	if is_lead_vehicle:
		x = []
	if not x.has(self):
		x.append(self)
	if follower_back_attached_car != null:
		follower_back_attached_car.addToTrain(x)
	if follower_front_attached_car != null:
		follower_front_attached_car.addToTrain(x)

