extends TextureButton

onready var canvas = get_parent().get_node("MiniMenuCanvas")

func toggle_menu():
	print("pressed")
	canvas.toggle_menu()



func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
