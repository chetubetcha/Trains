#extends Area2D
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
	NEWSPAPERS_AND_MAGAZINES,
	SAND_AND_GRAVEL,
	FERTILIZER,
	MEDICAL_SUPPLIES,
	IRON_ORE,
	FISH
}

var Cargo = {
	CargoType.COAL: {
		"name": "Coal",
		"value": 50,
		"origin": "Station A",
		"accepted_vehicles": [VehicleType.SEVEN_PLANK_TRUCK]
	},
	CargoType.OIL: {
		"name": "Oil",
		"value": 60,
		"origin": "Station B",
		"accepted_vehicles": [VehicleType.TANKER]
	},
	CargoType.GRAIN: {
		"name": "Grain",
		"value": 40,
		"origin": "Station C",
		"accepted_vehicles": [VehicleType.SEVEN_PLANK_TRUCK]
	},
	CargoType.LUMBER: {
		"name": "Lumber",
		"value": 30,
		"origin": "Station D",
		"accepted_vehicles": [VehicleType.FLATBED_TRUCK]
	},
	CargoType.LIVESTOCK: {
		"name": "Livestock",
		"value": 55,
		"origin": "Station E",
		"accepted_vehicles": [VehicleType.CATTLE_TRUCK]
	},
	CargoType.MANUFACTURED_GOODS: {
		"name": "Manufactured Goods",
		"value": 70,
		"origin": "Station F",
		"accepted_vehicles": [VehicleType.BOXCAR, VehicleType.VAN]
	},
	CargoType.TEXTILES: {
		"name": "Textiles",
		"value": 65,
		"origin": "Station G",
		"accepted_vehicles": [VehicleType.BOXCAR]
	},
	CargoType.STEEL: {
		"name": "Steel",
		"value": 75,
		"origin": "Station H",
		"accepted_vehicles": [VehicleType.FLATBED_TRUCK]
	},
	CargoType.MACHINERY: {
		"name": "Machinery",
		"value": 85,
		"origin": "Station I",
		"accepted_vehicles": [VehicleType.FLATBED_TRUCK]
	},
	CargoType.TOBACCO: {
		"name": "Tobacco",
		"value": 45,
		"origin": "Station J",
		"accepted_vehicles": [VehicleType.BOXCAR, VehicleType.VAN]
	},
	CargoType.PASSENGERS: {
		"name": "Passengers",
		"value": 30,
		"origin": "Station K",
		"accepted_vehicles": [VehicleType.PASSENGER, VehicleType.LUXURY_PASSENGER]
	},
	CargoType.COTTON: {
		"name": "Cotton",
		"value": 50,
		"origin": "Station L",
		"accepted_vehicles": [VehicleType.BOXCAR]
	},
	CargoType.AUTOMOBILES: {
		"name": "Automobiles",
		"value": 110,
		"origin": "Station M",
		"accepted_vehicles": [VehicleType.FLATBED_TRUCK]
	},
	CargoType.MAIL_AND_PACKAGES: {
		"name": "Mail and Packages",
		"value": 35,
		"origin": "Station N",
		"accepted_vehicles": [VehicleType.MAIL_TRUCK]
	},
	CargoType.MILK: {
		"name": "Milk",
		"value": 40,
		"origin": "Station O",
		"accepted_vehicles": [VehicleType.REFRIGERATED_CAR, VehicleType.TANKER]
	},
	CargoType.ALCOHOL: {
		"name": "Alcohol",
		"value": 75,
		"origin": "Station P",
		"accepted_vehicles": [VehicleType.VAN, VehicleType.BOXCAR]
	},
	CargoType.FRESH_PRODUCE: {
		"name": "Fresh Produce",
		"value": 45,
		"origin": "Station Q",
		"accepted_vehicles": [VehicleType.REFRIGERATED_CAR]
	},
	CargoType.CHEMICALS: {
		"name": "Chemicals",
		"value": 85,
		"origin": "Station R",
		"accepted_vehicles": [VehicleType.TANKER]
	},
	CargoType.FUEL: {
		"name": "Fuel",
		"value": 95,
		"origin": "Station S",
		"accepted_vehicles": [VehicleType.TANKER]
	},
	CargoType.NEWSPAPERS_AND_MAGAZINES: {
		"name": "Newspapers and Magazines",
		"value": 35,
		"origin": "Station T",
		"accepted_vehicles": [VehicleType.MAIL_TRUCK]
	},
	CargoType.SAND_AND_GRAVEL: {
		"name": "Sand and Gravel",
		"value": 55,
		"origin": "Station U",
		"accepted_vehicles": [VehicleType.SEVEN_PLANK_TRUCK]
	},
	CargoType.FERTILIZER: {
		"name": "Fertilizer",
		"value": 50,
		"origin": "Station V",
		"accepted_vehicles": [VehicleType.SEVEN_PLANK_TRUCK]
	},
	CargoType.MEDICAL_SUPPLIES: {
		"name": "Medical Supplies",
		"value": 105,
		"origin": "Station W",
		"accepted_vehicles": [VehicleType.REFRIGERATED_CAR]
	},
	CargoType.IRON_ORE: {
		"name": "Iron Ore",
		"value": 70,
		"origin": "Station X",
		"accepted_vehicles": [VehicleType.SEVEN_PLANK_TRUCK]
	},
	CargoType.FISH: {
		"name": "Fish",
		"value": 60,
		"origin": "Station Y",
		"accepted_vehicles": [VehicleType.REFRIGERATED_CAR]
	}
}

var cargoImages = {
	CargoType.COAL: preload("res://ResourceIcons/coal-wagon.png"),
	CargoType.OIL: preload("res://ResourceIcons/oil-drum.png"),
	CargoType.GRAIN: preload("res://ResourceIcons/grain.png"),
	CargoType.LUMBER: preload("res://ResourceIcons/wood-pile.png"),
	CargoType.LIVESTOCK: preload("res://ResourceIcons/cow.png"),
	CargoType.MANUFACTURED_GOODS: preload("res://ResourceIcons/cardboard-box-closed.png"),
	CargoType.TEXTILES: preload("res://ResourceIcons/rolled-cloth.png"),
	CargoType.STEEL: preload("res://ResourceIcons/i-beam.png"),
	CargoType.MACHINERY: preload("res://ResourceIcons/gears.png"),
	CargoType.TOBACCO: preload("res://ResourceIcons/smoking-pipe.png"),
	CargoType.PASSENGERS: preload("res://ResourceIcons/person.png"),
	CargoType.COTTON: preload("res://ResourceIcons/cotton-flower.png"),
	CargoType.AUTOMOBILES: preload("res://ResourceIcons/race-car.png"),
	CargoType.MAIL_AND_PACKAGES: preload("res://ResourceIcons/envelope.png"),
	CargoType.MILK: preload("res://ResourceIcons/milk-carton.png"),
	CargoType.ALCOHOL: preload("res://ResourceIcons/beer-stein.png"),
	CargoType.FRESH_PRODUCE: preload("res://ResourceIcons/fruit-bowl.png"),
	CargoType.CHEMICALS: preload("res://ResourceIcons/chemical-drop.png"),
	CargoType.FUEL: preload("res://ResourceIcons/gas-pump.png"),
	CargoType.NEWSPAPERS_AND_MAGAZINES: preload("res://ResourceIcons/newspaper.png"),
	CargoType.SAND_AND_GRAVEL: preload("res://ResourceIcons/powder.png"),
	CargoType.FERTILIZER: preload("res://ResourceIcons/fertilizer-bag.png"),
	CargoType.MEDICAL_SUPPLIES: preload("res://ResourceIcons/medicines.png"),
	CargoType.IRON_ORE: preload("res://ResourceIcons/ore.png"),
	CargoType.FISH: preload("res://ResourceIcons/fishing.png")
}
"""var cargoType = CargoType.COAL  # Replace with the actual cargo type you want to display.
your_sprite.texture = cargoImages[cargoType]"""


export(Array, CargoType) var available
export(Array, int) var availableAmounts
export(Array, CargoType) var demanded
export(Array, int) var demandedAmounts

var available_cargoes = {
	CargoType.PASSENGERS: 100,
	CargoType.COAL: 50,
	CargoType.LUMBER: 25,
	CargoType.IRON_ORE: 22
}
var demanded_cargoes = {
	CargoType.PASSENGERS: 60,
	CargoType.LUMBER: 15,
	CargoType.COAL: 15
}
func _process(delta):
	for child in get_parent().get_node("StationUI/Control/Panel").get_children():
		get_parent().get_node("StationUI/Control/Panel").rect_size = child.rect_size
		

func update_cargoes():
	available_cargoes.clear()
	demanded_cargoes.clear()
	for i in range(available.size()):
		if availableAmounts[i] > 0:
			available_cargoes[available[i]] = availableAmounts[i]
	for i in range(demanded.size()):
		if demandedAmounts[i] > 0:
			demanded_cargoes[demanded[i]] = demandedAmounts[i]
	print(available_cargoes)
	print(demanded_cargoes)

func get_cargoes_for_vehicle_type(vehicle_type):
	#print(vehicle_type)
	var possible_cargoes = []
	for cargo in available_cargoes:
		#print(cargo)
		print(Cargo[cargo]["accepted_vehicles"])
		if vehicle_type in Cargo[cargo]["accepted_vehicles"]:
			#print("so this should work") #works verified
			possible_cargoes.append(cargo)
	return possible_cargoes

func get_cargo_amount(cargo_enum):
	var amount = 0
	
	if cargo_enum in available_cargoes:
		amount = available_cargoes[cargo_enum]
	return amount
func deduct_cargo(cargo_enum, amount):
	available_cargoes[cargo_enum] -= amount
	# Make sure it doesn't go below 0
	available_cargoes[cargo_enum] = max(0, available_cargoes[cargo_enum])
	emit_signal("cargo_changed")
func consume_cargo(cargo_enum, amount):
	var payment = 0
	
	# Check if the cargo_enum is in demanded_cargoes
	if cargo_enum in demanded_cargoes:
		# Determine the payment amount or any other logic you want to add
		# Let's assume you pay based on the value of the cargo from the Cargo dictionary
		payment = min(amount, demanded_cargoes[cargo_enum]) * Cargo[cargo_enum]["value"]
		
		demanded_cargoes[cargo_enum] -= amount
		# Make sure it doesn't go below 0
		demanded_cargoes[cargo_enum] = max(0, demanded_cargoes[cargo_enum])
	print("Payment - ",payment)
	return payment

func get_cargo_key(cargo):
	# Return the key of the cargo based on the value. Useful for reverse lookup.
	for key in Cargo:
		if Cargo[key] == cargo:
			return key
	return null



func _ready():
	# Connect a signal to detect when a vehicle enters the station's area.
	update_cargoes()
	connect("body_entered", self, "_on_body_entered")
	#createSupplyDemandUI()
	StationUI()

func _present_loading_options(cargoes):
	# Logic to present the loading options to the player.
	# This can be a UI pop-up or some other mechanism.
	pass

func StationUI():
	var panel = Panel.new()
	var hb = HBoxContainer.new()  # Create an HBoxContainer for each cargo entry
	var vba = VBoxContainer.new()
	var vbd = VBoxContainer.new()
	var s = Vector2(24, 24) #image size
	var i = 0
	for e in available_cargoes.keys():
		var c = str(e)  # Convert CargoType enum to a string for the name
		#print("Cargo Name:", c)
		#print(available_cargoes[e])
		var h = HBoxContainer.new()
		var cargo_logo = TextureRect.new()
		cargo_logo.texture = cargoImages[e]
		cargo_logo.rect_min_size = s
		cargo_logo.expand = true
		h.add_child(cargo_logo)
		var cargo_label = Label.new()
		cargo_label.text = Cargo[e]['name'] + ": " + str(available_cargoes[e])
		h.add_child(cargo_label)
		vba.add_child(h)
	print(demanded_cargoes.size())
	for e in demanded_cargoes.keys():
		var c = str(e)  # Convert CargoType enum to a string for the name
		print(i)
		var h2 = HBoxContainer.new()
		var cargo_logo = TextureRect.new()
		cargo_logo.texture = cargoImages[e]
		cargo_logo.rect_min_size = s
		cargo_logo.expand = true
		h2.add_child(cargo_logo)
		var cargo_label = Label.new()
		cargo_label.text = Cargo[e]['name'] + ": " + str(demanded_cargoes[e])
		h2.add_child(cargo_label)
		vbd.add_child(h2)
	hb.add_child(vba)
	hb.add_child(vbd)
	get_parent().get_node("StationUI/Control/Panel").add_child(hb)

