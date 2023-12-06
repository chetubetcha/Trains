extends CanvasLayer
#GAME MANAGER FOR ECONOMY AND HIGH LEVEL FUNCTIONS

export var money = 100000

var trainList = []
var sizeTracker = 0
var trainListIndex = 0 

var d = 1
var day = "Current Day "+ str(d)

func _ready():
	UpdateDay()
func _process(delta):
	if sizeTracker != trainList.size():
		sizeTracker = trainList.size()
		change()
	var x = 0
	for train in trainList:
		if train.SELECTED == true:
			get_node("Control2/MarginContainer3/ScrollContainer/HBoxContainer").Highlight(x)
		x+=1
		# You might still need process for other things, but it won't check the train list size here

func selectTrain(i):
	print("train selected, ",i)
	for train in trainList:
		train.SELECTED = false
	trainList[i].SELECTED = true

# This function handles the logic for when the train list size changes
func change():
	$Control2/MarginContainer3/ScrollContainer/HBoxContainer.create_options(trainList)
	
func NextDay():
	d += 1
	UpdateDay()
func UpdateDay():
	get_node("Control2/MarginContainer2/VBoxContainer/Day").text = day
	

	# Implement the UI update logic here based on the current train list
