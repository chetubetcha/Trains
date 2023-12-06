extends VBoxContainer
# Global.gd
var engines = []
var selected_engine = null

# Sidebar.gd - attached to the VBoxContainer or the parent node holding the menu items
func update_sidebar():
	# Clear the existing list
	for child in get_children():
		remove_child(child)
		child.queue_free()

	# Populate the list with new buttons for each engine
	for engine in engines:
		var button = Button.new()
		button.text = engine.name # or any identifier you have for engines
		button.connect("pressed", self, "_on_engine_selected", [engine])
		add_child(button)

func _on_engine_selected(engine):
	set_selected_engine(engine)
	# Update your UI or states as required


func register_engine(engine):
	engines.append(engine)

func unregister_engine(engine):
	engines.erase(engine)

func set_selected_engine(engine):
	selected_engine = engine

func get_selected_engine():
	return selected_engine
