extends Node
class_name State

var target : Node # We are a state of an arbitrary target
var transitions : Node # Has true/false functions that decide if you can transition to a state

# Called once when entering the state
func enter():
	pass

# Called every frame when the state is active (most likely physics frames)
func update(_delta):
	pass

# Called once when exiting the state
func exit():
	pass

# Check if conditions are met to change state
# If so, return that state. Otherwise return null
func try_transition() -> State:
	return null
