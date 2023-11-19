@tool
extends EditorPlugin

const SIDE_WIDTH = 10000.0
const SIDE_HEIGHT = 20000.0
const VERT_HEIGHT = 10000.0

var selected_room
var selected_extents

var border_width = 3
var unfocus_color = Color(0.2,0.2,0.4,0.8)
var active_border_color = Color(0.8,0.8,0.9,0.8)
var inactive_border_color = Color(0.8,0.8,0.9,0.3)

var rec_left
var rec_top
var rec_right
var rec_bottom
var rec_above

var edi = get_editor_interface()

func _handles(object):
	# To trigger `forward_canvas_draw_over_viewport`
	return object is Node2D

func get_helper():
	return get_tree().get_nodes_in_group("helper").pop_back()

func _ready():   
	if Engine.is_editor_hint():
		set_process_input(true);


func _process(delta):
	if Engine.is_editor_hint():
		change_selected_room()
#		update_overlays()
		if edi.get_selection().get_selected_nodes().size() > 0:
			if edi.get_selection().get_selected_nodes()[0].is_in_group("editor_room"):
				selected_room = edi.get_selection().get_selected_nodes()[0]

func set_border_rects():
	selected_extents = selected_room.get_node("CollisionShape2D").shape.extents
	rec_left = Rect2(selected_room.get_node("CollisionShape2D").global_position - Vector2(selected_extents.x + SIDE_WIDTH, SIDE_HEIGHT / 2),Vector2(SIDE_WIDTH,SIDE_HEIGHT))
	rec_right = Rect2(selected_room.get_node("CollisionShape2D").global_position - Vector2(-selected_extents.x, SIDE_HEIGHT / 2),Vector2(SIDE_WIDTH,SIDE_HEIGHT))

	rec_top = Rect2(selected_room.get_node("CollisionShape2D").global_position - Vector2(selected_extents.x, selected_extents.y + VERT_HEIGHT), Vector2(selected_extents.x * 2,VERT_HEIGHT))
	rec_bottom = Rect2(selected_room.get_node("CollisionShape2D").global_position - Vector2(selected_extents.x, -selected_extents.y), Vector2(selected_extents.x * 2,VERT_HEIGHT))

	rec_above = Rect2(selected_room.get_node("CollisionShape2D").global_position - Vector2(selected_extents.x, selected_extents.y), Vector2(selected_extents.x * 2, 0))

#func _forward_canvas_draw_over_viewport(overlay):
#	if Engine.is_editor_hint():
#		if selected_room:
#			set_border_rects()
#			overlay.draw_rect(rec_left, unfocus_color)
#			overlay.draw_rect(rec_right, unfocus_color)
#			overlay.draw_rect(rec_bottom, unfocus_color)
#			overlay.draw_rect(rec_top, unfocus_color)
#			overlay.draw_rect(rec_above, inactive_border_color)
#			overlay.draw_rect(extent2rect(selected_room), active_border_color, false, border_width)
#
#		for room in get_tree().get_nodes_in_group("room"):
#			if room != selected_room:
#				overlay.draw_rect(extent2rect(room), inactive_border_color, false, border_width)
#				overlay.draw_rect(extent2rect(room), Color(1,1,1,0.1))


var caps_pressed = false
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
		if event.as_text() == "Alt+1":
			select_node(selected_room.get_node("Resetables/TileMap"))
		if event.as_text() == "Alt+2":
			select_node(selected_room.get_node("Resetables"))
		if event.as_text() == "Alt+3":
			select_node(selected_room)
		
		if event.as_text() == "Ctrl+P": # Move player to cursor
			var p = get_tree().get_nodes_in_group("player").pop_back()
			if p:
				var mousepos = p.get_viewport().get_mouse_position()
				p.global_position = Vector2(round(mousepos.x/6) * 6, round(mousepos.y/6) * 6) # snap to grid
		
		if event.as_text() == "CapsLock" && event.pressed:
			caps_pressed = true
		if event.as_text() == "CapsLock" && !event.pressed:
			caps_pressed = false

func change_selected_room():
	if Engine.is_editor_hint() && edi.get_selection().get_selected_nodes().size() > 0:
		if edi.get_selection().get_selected_nodes()[0].is_in_group("room"):
			if selected_room != edi.get_selection().get_selected_nodes()[0]:
				selected_room = edi.get_selection().get_selected_nodes()[0]

func select_node(node:Node):
	edi.get_selection().clear()
	edi.get_selection().add_node(node)
	edi.get_selection().emit_signal("selection_changed")

func set_equivalent_child(selected_node):
	if selected_node == null:
		return
	elif selected_node.name == "TileMap":
		select_node(selected_room.get_node("Resetables/TileMap"))

func extent2rect(room):
	var extent = room.get_node("CollisionShape2D").shape.extents
	return Rect2(room.get_node("CollisionShape2D").global_position-extent,extent*2)
