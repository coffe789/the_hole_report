extends Area2D

const MIN_ROOM_WIDTH = 224
const MIN_ROOM_HEIGHT = 126

const UP_TRANSITION_BOOST = -400
var resetables

func _ready():
	if int(position.x) != position.x or int(position.y) != position.y\
			or int(position.x) % 16 != 0 or int(position.y) % 16 != 0:
		push_error("Room [" + name + "] is not snapped to the 16x16 grid")
	if ($CollisionShape2D.position != Vector2.ZERO):
		push_error("Room [" + name + "]'s collision shape has an offset. Please move it to position (0,0)")
	if ($CollisionShape2D.shape.size.x < MIN_ROOM_WIDTH):
		push_error("Room [" + name + "]'s width is smaller than the minimum")
	if ($CollisionShape2D.shape.size.y < MIN_ROOM_HEIGHT):
		push_error("Room [" + name + "]'s height is smaller than the minimum")
	
	if $Resetables.get_child_count():
		resetables = $Resetables.create_scene()
		$Resetables.queue_free()

func _on_area_entered(area):
	if area.is_in_group("player_room_finder"):
		Global.room_changed.emit(self)
		snap_player_to_room()
		
		if resetables:
			call_deferred("add_child", resetables.instantiate())

func _on_area_exited(area):
	if resetables and area.is_in_group("player_room_finder"):
		$Resetables.queue_free()

const snap_fatness = 6.0/2 + 1
const snap_up_height = 10.0 / 2 + 1
const snap_down_height = 10.0 / 2 + 1
func snap_player_to_room():
	var p = Global.get_unique("player")
	var cam = Global.get_unique("camera")
	
	if not cam or not p or cam.current_room == self:
		return
	
	if p.global_position.x - snap_fatness < cam.limit_left:
		p.global_position.x = cam.limit_left + snap_fatness
	elif p.global_position.x + snap_fatness > cam.limit_right:
		p.global_position.x = cam.limit_right - snap_fatness
	
	if p.global_position.y - snap_down_height < cam.limit_top:
		p.global_position.y = cam.limit_top + snap_down_height
	elif p.global_position.y + snap_up_height > (cam.limit_bottom):
		p.global_position.y = cam.limit_bottom - snap_up_height
		if p.velocity.y > UP_TRANSITION_BOOST:
			p.velocity.y = UP_TRANSITION_BOOST
			p.has_ended_jump = true
