# A set of wheels that follow along Tracks
#
# TrainVehicles generally have two of these
class_name TrainWheel
extends PathFollow2D

signal at_track_head
signal at_track_tail
signal moved

enum Directions {HEADWARD, TAILWARD}

var direction = Directions.TAILWARD
var follow_distance
var current_track
var current_track_length
onready var sprite = $Sprite

var distanceMovedInPeriod = 0

var connectedTrain

# Put the wheel on a track
func set_track(track: Path2D):
	print("Set Track is called")
	_disconnect_from_track()
	if connectedTrain == null:
		connectedTrain = get_parent()
	connectedTrain.assignWheel(self)
	get_parent().remove_child(self)
	print(track)
	track.add_child(self)
	current_track = track
	current_track.currentWheels.append(self)
	current_track_length = track.curve.get_baked_length()
	connect("at_track_head", track, "wheel_at_head")
	connect("at_track_tail", track, "wheel_at_tail")

# Set the direction of "forward travel" along the track to be towards the tail
func head_to_tail():
	direction = Directions.TAILWARD
	sprite.flip_v = false

# Set the direction of "forward travel" along the track to be towards the head
func tail_to_head():
	direction = Directions.HEADWARD
	sprite.flip_v = true

# Place this wheel a specific distance behind another one
func follow(leader, distance):
	follow_distance = distance
	#print(leader.direction)
	direction = leader.direction
	#set_track(leader.current_track)
	offset = leader.offset
	move_as_follower(-distance, leader.offset, leader.direction, leader.current_track, leader.current_track_length)

# Move by some distance
func move(distance):
	if !current_track: return
	if(distance > 0):
		distanceMovedInPeriod += distance
	else:
		distanceMovedInPeriod -= distance
	var original_offset = offset
	offset += distance if direction == Directions.TAILWARD else -distance
	_change_track_if_end(original_offset, distance)
	emit_signal("moved", distance, offset, direction, current_track, current_track_length)

# Jump to the predefined follow distance if there's room, or else just move the specified distance
func move_as_follower(distance, leader_offset, leader_direction, leader_track, leader_track_length):
	#print(distance, leader_offset, leader_direction, leader_track, leader_track_length)
	if leader_offset > follow_distance && leader_offset < leader_track_length - follow_distance:
		#print("here1")
		if leader_track != current_track:
			#print("here2")
			_put_on_leader_track(leader_track, leader_direction)
		_set_at_distance_from_leader(distance, leader_offset, leader_direction)
	else:
		move(distance)

# Put on the same track, with same orientation, as the wheel it's following
func _put_on_leader_track(leader_track, leader_direction):
	if leader_track != current_track:
		set_track(leader_track)
		head_to_tail() if leader_direction == Directions.TAILWARD else tail_to_head()

# Position exactly at predetermined distance from the wheel it's following
func _set_at_distance_from_leader(distance, leader_offset, leader_direction):
	var original_offset = offset
	offset = leader_offset + (-follow_distance if leader_direction == Directions.TAILWARD else follow_distance)
	_change_track_if_end(original_offset, distance)
	emit_signal("moved", distance, offset, direction, current_track, current_track_length)

# Signal that the wheel has reached the end of the segment
func _change_track_if_end(original_offset, distance_moved):
	print("LEAVING TRACK")
	var index = current_track.currentWheels.find(self)
	current_track.currentWheels.remove(index)
	if !current_track: return
	if unit_offset <= 0:
		emit_signal("at_track_head", self, abs(original_offset - abs(distance_moved)), distance_moved > 0)
	elif unit_offset >= 1:
		emit_signal("at_track_tail", self, original_offset + abs(distance_moved) - current_track_length, distance_moved > 0)

# Disconnect signals
func _disconnect_from_track():
	if current_track:
		disconnect("at_track_head", current_track, "wheel_at_head")
		disconnect("at_track_tail", current_track, "wheel_at_tail")
