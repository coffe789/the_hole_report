extends Trigger

enum Limit_dirs{
	LEFT_LIMIT,
	RIGHT_LIMIT,
	ABOVE_LIMIT,
	BELOW_LIMIT
}

@export var unset_on_leave = true
@export var limit_direction = Limit_dirs.LEFT_LIMIT

var limit_pos # Position of axis. Whether is X/Y axis depends on direction
var old_limit_pos

func _ready():
	super()
	set_limit_pos()
	print("here exist")


func on_enter():
	# Global.emit_signal("set_cam_limit", limit_direction, limit_pos)
	pass
	


func activate():
	Global.emit_signal("set_cam_limit", limit_direction, limit_pos)
	print("here set")

func on_leave():
	if unset_on_leave:
		get_old_limit()
		Global.emit_signal("set_cam_limit", limit_direction, old_limit_pos)


func get_old_limit():
	if Global.get_unique("camera").current_room:
		var room = Global.get_unique("camera").current_room
		var room_shape = room.get_node("CollisionShape2D")
		var room_size = room_shape.shape.extents * 2
		match limit_direction:
			Limit_dirs.LEFT_LIMIT:
				old_limit_pos = round(room_shape.global_position.x + room_size.x / 2)
			Limit_dirs.RIGHT_LIMIT:
				old_limit_pos = round(room_shape.global_position.x - room_size.x / 2)
			Limit_dirs.ABOVE_LIMIT:
				old_limit_pos = round(room_shape.global_position.y + room_size.y / 2)
			Limit_dirs.BELOW_LIMIT:
				old_limit_pos = round(room_shape.global_position.y - room_size.y / 2)


func set_limit_pos():
	match limit_direction:
		Limit_dirs.LEFT_LIMIT:
			limit_pos = right_bound
		Limit_dirs.RIGHT_LIMIT:
			limit_pos = left_bound
		Limit_dirs.ABOVE_LIMIT:
			limit_pos = bottom_bound
		Limit_dirs.BELOW_LIMIT:
			limit_pos = top_bound

