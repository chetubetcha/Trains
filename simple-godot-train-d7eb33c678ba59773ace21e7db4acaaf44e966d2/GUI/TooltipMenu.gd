extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if get_parent().get_parent().get_parent().get_parent().get_parent().get_node("TrackBuilder").track_buildable or get_parent().get_parent().get_parent().get_parent().get_parent().get_node("TrackBuilder").switch_buildable:
		var cost = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("TrackBuilder").total_length()
		# Format to two decimal places and insert commas
		self.text = "Cost - $" + format_cost(cost)
	else:
		#FIND CURRENT TRAIN DETAILS
		if get_parent().get_parent().get_parent().get_parent().trainList.size() > 0:
			#self.text = get_parent().get_parent().get_parent().get_parent().trainList[0].name
			self.text = str(get_parent().get_parent().get_parent().get_parent().trainList[0].wheelForTracking.distanceMovedInPeriod)
			get_parent().get_node("ProgressBar").max_value = 1500
			get_parent().get_node("ProgressBar").value = get_parent().get_parent().get_parent().get_parent().trainList[0].wheelForTracking.distanceMovedInPeriod
			#pass
		else:
			pass  # Or some other logic

func format_cost(cost: float) -> String:
	# Format the number with two decimal places
	var formatted_cost = "%.2f" % cost
	# Find the position to start inserting commas, which is before the decimals
	var insert_position = formatted_cost.find(".") - 3
	
	# Insert commas every three digits before the decimal point
	while insert_position > 0:
		formatted_cost = formatted_cost.insert(insert_position, ",")
		insert_position -= 3
	
	return formatted_cost
