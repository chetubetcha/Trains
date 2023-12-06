extends CanvasLayer

enum CargoType {
	COAL,
	OIL,
	GRAIN,
	LUMBER,
	LIVESTOCK,
	MANUFACTURED_GOODS,
	TEXTILES,
	STEEL,
	MACHINERY,
	TOBACCO,
	PASSENGERS,
	COTTON,
	AUTOMOBILES,
	MAIL_AND_PACKAGES,
	MILK,
	ALCOHOL,
	FRESH_PRODUCE,
	CHEMICALS,
	FUEL,
	NEWSPAPERS_AND_MAGAZINES,SAND_AND_GRAVEL,
	FERTILIZER,
	MEDICAL_SUPPLIES,
	IRON_ORE,
	FISH
}
enum VehicleType {
	SEVEN_PLANK_TRUCK, TANKER, FLATBED_TRUCK, CATTLE_TRUCK, BOXCAR, VAN, PASSENGER, LUXURY_PASSENGER,MAIL_TRUCK, REFRIGERATED_CAR
}
var Cargo = {
	CargoType.COAL: {
		"value": 50,
		"origin": "Station A",
		"accepted_vehicles": [VehicleType.SEVEN_PLANK_TRUCK]
	},
	CargoType.OIL: {
		"value": 60,
		"origin": "Station B",
		"accepted_vehicles": [VehicleType.TANKER]
	},
	CargoType.GRAIN: {
		"value": 40,
		"origin": "Station C",
		"accepted_vehicles": [VehicleType.SEVEN_PLANK_TRUCK]
	},
	CargoType.LUMBER: {
		"value": 30,
		"origin": "Station D",
		"accepted_vehicles": [VehicleType.FLATBED_TRUCK]
	},
	CargoType.LIVESTOCK: {
		"value": 55,
		"origin": "Station E",
		"accepted_vehicles": [VehicleType.CATTLE_TRUCK]
	},
	CargoType.MANUFACTURED_GOODS: {
		"value": 70,
		"origin": "Station F",
		"accepted_vehicles": [VehicleType.BOXCAR, VehicleType.VAN]
	},
	CargoType.TEXTILES: {
		"value": 65,
		"origin": "Station G",
		"accepted_vehicles": [VehicleType.BOXCAR]
	},
	CargoType.STEEL: {
		"value": 75,
		"origin": "Station H",
		"accepted_vehicles": [VehicleType.FLATBED_TRUCK]
	},
	CargoType.MACHINERY: {
		"value": 85,
		"origin": "Station I",
		"accepted_vehicles": [VehicleType.FLATBED_TRUCK]
	},
	CargoType.TOBACCO: {
		"value": 45,
		"origin": "Station J",
		"accepted_vehicles": [VehicleType.BOXCAR, VehicleType.VAN]
	},
	CargoType.PASSENGERS: {
		"value": 30,
		"origin": "Station K",
		"accepted_vehicles": [VehicleType.PASSENGER, VehicleType.LUXURY_PASSENGER]
	},
	CargoType.COTTON: {
		"value": 50, 
		"origin": "Station L",
		"accepted_vehicles": [VehicleType.BOXCAR]
		},
	CargoType.AUTOMOBILES: {
		"value": 110,
		"origin": "Station M",
		"accepted_vehicles": [VehicleType.FLATBED_TRUCK]
	},
	CargoType.MAIL_AND_PACKAGES: {
		"value": 35,
		"origin": "Station N",
		"accepted_vehicles": [VehicleType.MAIL_TRUCK]
	},
	CargoType.MILK: {
		"value": 40,
		"origin": "Station O",
		"accepted_vehicles": [VehicleType.REFRIGERATED_CAR, VehicleType.TANKER]
	},
	CargoType.ALCOHOL: {
		"value": 75,
		"origin": "Station P",
		"accepted_vehicles": [VehicleType.VAN, VehicleType.BOXCAR]
	},
	CargoType.FRESH_PRODUCE: {
		"value": 45,
		"origin": "Station Q",
		"accepted_vehicles": [VehicleType.REFRIGERATED_CAR]
	},
	CargoType.CHEMICALS: {
		"value": 85,
		"origin": "Station R",
		"accepted_vehicles": [VehicleType.TANKER]
	},
	CargoType.FUEL: {
		"value": 95,
		"origin": "Station S",
		"accepted_vehicles": [VehicleType.TANKER]
	},
	CargoType.NEWSPAPERS_AND_MAGAZINES: {
		"value": 35,
		"origin": "Station T",
		"accepted_vehicles": [VehicleType.MAIL_TRUCK]
	},
	CargoType.SAND_AND_GRAVEL: {
		"value": 55,
		"origin": "Station U",
		"accepted_vehicles": [VehicleType.SEVEN_PLANK_TRUCK]
	},
	CargoType.FERTILIZER: {
		"value": 50,
		"origin": "Station V",
		"accepted_vehicles": [VehicleType.SEVEN_PLANK_TRUCK]
	},
	CargoType.MEDICAL_SUPPLIES: {
		"value": 105,
		"origin": "Station W",
		"accepted_vehicles": [VehicleType.REFRIGERATED_CAR]
	},
	CargoType.IRON_ORE: {
		"value": 70,
		"origin": "Station X",
		"accepted_vehicles": [VehicleType.SEVEN_PLANK_TRUCK]
	},
	CargoType.FISH: {
		"value": 60,
		"origin": "Station Y",
		"accepted_vehicles": [VehicleType.REFRIGERATED_CAR]
	}
}
onready var dropdown = $Panel/LoadingDropdown
var is_loading_mode = true


func _ready():
	$Panel.visible = false
	dropdown.connect("item_selected", self, "_on_item_selected")
	$Panel/HSlider.connect("value_changed", self, "_on_slider_value_changed")
	$Panel/Button.connect("pressed", self, "_on_load_button_pressed")

var current_station = null

func update_dropdown_with_cargoes(vehicle_type):
	print("current station - ", current_station)
	
	# Get available cargoes at the current station
	var available_cargoes_at_station = current_station.get_cargoes_for_vehicle_type(vehicle_type)
	
	dropdown.clear()
	
	# Iterate only over the cargoes available at the station
	for cargo_enum in available_cargoes_at_station:
		# No need for an additional check; just add the item to the dropdown
		dropdown.add_item(CargoType.keys()[cargo_enum] + " - " + str(current_station.get_cargo_amount(cargo_enum))) 
	if dropdown.get_item_count() > 0:
		_on_item_selected(0) # Dynamically add the item using the enum's string value

func _on_item_selected(index):
	if is_loading_mode:
		var selected_cargo_enum = CargoType.keys().find(dropdown.get_item_text(index).split(" - ")[0])
		var selected_cargo_data = Cargo[selected_cargo_enum]
		var max_value = min(get_parent().get_parent().capacity-get_parent().get_parent().held_amount, current_station.get_cargo_amount(selected_cargo_enum))
		$Panel/HSlider.max_value = max_value
		$Panel/HSlider.tick_count = max_value+1
		$Panel/HSlider.value = 0
	else:
		var selected_cargo_enum = CargoType.keys().find(dropdown.get_item_text(index).split(" - ")[0])
		var selected_cargo_data = Cargo[selected_cargo_enum]
		var max_value = get_parent().get_parent().held_amount
		$Panel/HSlider.max_value = max_value
		$Panel/HSlider.tick_count = max_value+1
		$Panel/HSlider.value = 0

func toggle_menu():
	# Offset from the center of the parent node
	var offset = Vector2(81, 10)
	$Panel.rect_position = get_parent().global_position #- $Panel.rect_size / 2 + offset
	#$Panel.rect_position = - $Panel.rect_size / 2
	
	$Panel.visible = not $Panel.visible

func set_station(station):
	current_station = station

func null_station():
	current_station = null

func _on_LoadButton_pressed():
	toggle_menu()
	update_dropdown_with_cargoes(get_parent().get_parent().vehicle_type)


func _on_ExitButton_pressed():
	toggle_menu()
	
func _on_slider_value_changed(value):
	$Panel/ProgressBar.value = (get_parent().get_parent().held_amount / get_parent().get_parent().capacity) * 100
	$Panel/Counter.text = str($Panel/HSlider.value)
	if !is_loading_mode:
		var key = get_parent().get_parent().held_cargo.keys()[0]
		if get_parent().get_parent().held_cargo[key][0]["source"] == current_station.name:
			$Panel/Button.text = "Unload - $0"
		else:
			var value_for_selected_cargo = Cargo[0]["value"]
			$Panel/Button.text = "Unload - $" + str($Panel/HSlider.value * value_for_selected_cargo)
	
func _on_load_button_pressed():
	var selected_cargo_enum = CargoType.keys().find(dropdown.get_item_text(dropdown.selected).split(" - ")[0])
	var amount = $Panel/HSlider.value

	if is_loading_mode:
		print("Loading - "+str(selected_cargo_enum)+", "+str(amount))
		# Deduct from station and add to vehicle with origin
		current_station.deduct_cargo(selected_cargo_enum, amount)
		get_parent().get_parent().add_cargo(selected_cargo_enum, amount, current_station.name)
	else:
		# Check the origin of the cargo before unloading
		var cargoes_for_selected_type = get_parent().get_parent().held_cargo[selected_cargo_enum]
	
		for cargo in cargoes_for_selected_type:
		# - We're directly accessing the 'amount' and 'source' fields from the 'cargo' dictionary.
			if cargo["source"] == current_station.name:
				print("Cannot sell this cargo at the same station it was bought from!")
				return

		# Logic for unloading
		var payment = current_station.consume_cargo(selected_cargo_enum, amount) 
		get_parent().get_parent().deduct_cargo(selected_cargo_enum, amount)

	update_dropdown_with_cargoes(get_parent().get_parent().vehicle_type)
	"""else:
		# Check the origin of the cargo before unloading
		for cargo in get_parent().get_parent().held_cargo:
			print(get_parent().get_parent().held_cargo)
			if cargo.type == selected_cargo_enum and cargo.origin == current_station.name:
				print("Cannot sell this cargo at the same station it was bought from!")
				return"""


func on_item_selected(index):
	_on_item_selected(index)
	
func toggle_mode():
	is_loading_mode = not is_loading_mode
	
	# Update button text based on mode
	if is_loading_mode:
		$Panel/Button.text = "Load"
		$Panel/LoadUnload.text = "Load Cargo"
	else:
		var value_for_selected_cargo = Cargo[0]["value"]
		var key = get_parent().get_parent().held_cargo.keys()[0]
		if get_parent().get_parent().held_cargo[key][0]["source"] == current_station.name:
			$Panel/Button.text = "Unload - $0"
		else:
			$Panel/Button.text = "Unload - $" + str($Panel/HSlider.value * value_for_selected_cargo)
		$Panel/LoadUnload.text = "Unload Cargo"
	update_dropdown_with_cargoes(get_parent().get_parent().vehicle_type)
