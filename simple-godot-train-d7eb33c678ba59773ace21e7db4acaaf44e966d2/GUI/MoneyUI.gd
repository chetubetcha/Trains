extends Label

func _process(delta):
	#self.text = "$ - "+ format_score(str(get_parent().get_parent().get_parent().get_parent().money))
	self.text = "$ - "+ str(format_cost(get_parent().get_parent().get_parent().get_parent().money))

func format_score(score : String) -> String:
	var i : int = score.length() - 3
	while i > 0:
		score = score.insert(i, ",")
		i = i - 3
	return score

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
