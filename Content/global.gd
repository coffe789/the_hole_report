@tool
extends Node

signal room_changed(room)

var is_map_ready = false

func get_unique(group_name : String):
	return get_tree().get_nodes_in_group(group_name).pop_back()


func _input(event):
	if Engine.is_editor_hint():
		if event is InputEventMouseButton && event.button_index == 1 && !event.pressed:
			for room in get_tree().get_nodes_in_group("room"):
				room.get_node("CollisionShape2D").position = Vector2.ZERO

#func get_my_room(me:Node):
#	var p = me.get_parent()
#	while (p != null):
#		if p.is_in_group("room"):
#			return p
#		p = p.get_parent()
#	return null # Not in a room

func do_freeze_frames(freeze_time : float = 0.075):
	get_tree().paused = true
	await get_tree().create_timer(freeze_time).timeout
	get_tree().paused = false
