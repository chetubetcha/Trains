extends Camera2D

# Zoom parameters
export var zoom_speed: float = 0.1
export var max_zoom: float = 20.0
export var min_zoom: float = 0.5

# Pan parameters
export var pan_speed: float = 5.0
var dragging: bool = false
var last_mouse_pos: Vector2 = Vector2()

func _ready():
	self.zoom = Vector2(1, 1)  # Set initial zoom level

func _input(event):
	# Zooming with Mouse Scroll Wheel
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			zoom.x -= zoom_speed
			zoom.y -= zoom_speed
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoom.x += zoom_speed
			zoom.y += zoom_speed

		# Clamp zoom values
		zoom.x = clamp(zoom.x, min_zoom, max_zoom)
		zoom.y = clamp(zoom.y, min_zoom, max_zoom)

	# Panning with Right Mouse Button
	if event is InputEventMouseButton and event.button_index == BUTTON_MIDDLE:
		if event.pressed:
			dragging = true
			last_mouse_pos = event.global_position
		else:
			dragging = false

	if dragging and event is InputEventMouseMotion:
		var drag_distance = last_mouse_pos - event.global_position
		self.global_position += drag_distance * pan_speed * zoom.x
		last_mouse_pos = event.global_position

