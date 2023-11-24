@tool
extends EditorPlugin

# WARNING: This code has a lot of leftover bullshit
#          READ WITH CAUTION

var edi = get_editor_interface()
var selected_room
var trigger_idx = -1

func _ready():   
	if Engine.is_editor_hint():
		set_process_input(true);

func func_is_in_group(group_name):
	return func (node): return node.is_in_group(group_name)

func _input(event):
	# Mouse in viewport coordinates
	if event is InputEventMouseButton && event.button_index == 3 && event.double_click && Engine.is_editor_hint():
		if get_tree().get_nodes_in_group("room").size() != 0:
			for room in get_tree().get_nodes_in_group("room"):
				var is_mouse_in_room = extent2rect(room).has_point(get_tree().get_nodes_in_group("room")[0].get_viewport().get_mouse_position())
				if is_mouse_in_room:
					selected_room = room
					
					var editor_selection = null
					if edi.get_selection().get_selected_nodes().size() > 0:
						editor_selection = edi.get_selection().get_selected_nodes()[0]
					
					select_node(room)
					await get_tree().process_frame
					await get_tree().process_frame
					set_equivalent_child(editor_selection)
		
	if !(event is InputEventMouseMotion or event is InputEventJoypadMotion) and event.pressed and selected_room and Engine.is_editor_hint():
		match event.as_text():
			"Alt+1":
				select_node(selected_room)
			"Alt+2":
				select_node(selected_room.get_node("Resetables"))
			"Alt+3":
				select_node(selected_room.get_node("Resetables/TileMap"))
			"Alt+4":
				var ts = selected_room.get_node("Resetables").get_children().filter(func_is_in_group("trigger"))
				if !ts.is_empty():
					trigger_idx += 1
					trigger_idx %= ts.size()
					select_node(ts[trigger_idx])
			"Alt+R":
				select_node(selected_room.get_parent())
			"Alt+E": # Move player to cursor
				var p = get_tree().get_nodes_in_group("player").pop_back()
				if p:
					var mousepos = p.get_viewport().get_mouse_position()
					p.global_position = Vector2(round(mousepos.x/6) * 6, round(mousepos.y/6) * 6) # snap to grid
			"Alt+C":
				var rooms = get_tree().get_nodes_in_group("room")
				var complete = rooms.filter(func (r): return !r.name.contains("Room"))
				prints(complete.size(), "/", rooms.size())
				print(str(rooms.size()-complete.size()) + " rooms remaining")
				var time_left = ceil((1704027600 - Time.get_unix_time_from_system()) / (60*60*24))
				print(str(time_left) + " days remaining")
				
func select_node(node:Node):
	edi.get_selection().clear()
	edi.get_selection().add_node(node)
	edi.get_selection().emit_signal("selection_changed")
	if node.is_in_group("room"):
		selected_room = node
		trigger_idx = -1

func set_equivalent_child(selected_node):
	if selected_node == null:
		return
	elif selected_node.name == "TileMap":
		select_node(selected_room.get_node("Resetables/TileMap"))

func extent2rect(room):
	var extent = room.get_node("CollisionShape2D").shape.extents
	return Rect2(room.get_node("CollisionShape2D").global_position-extent,extent*2)
