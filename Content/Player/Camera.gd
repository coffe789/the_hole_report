extends Camera2D

var current_room = null
var cam_offset = Vector2.ZERO

func _ready():
	Global.room_changed.connect(on_room_changed)
	Global.set_camera_offset.connect(set_cam_offset)
	Global.set_cam_limit.connect(set_limits)

func set_cam_offset(new_offset, ignore_vector):
	if ignore_vector.x == 0:
		cam_offset.x = new_offset.x
	if ignore_vector.y == 0:
		cam_offset.y = new_offset.y

func _physics_process(_delta):
	var p = Global.get_unique("player")
	if p:
		global_position = p.global_position + cam_offset

func set_camera_limits(room_shape):
	var room_size = room_shape.shape.extents * 2
	limit_left = round(room_shape.global_position.x - room_size.x / 2)
	limit_top = round(room_shape.global_position.y - room_size.y / 2)
	limit_right = round(limit_left + room_size.x)
	limit_bottom = round(limit_top + room_size.y)

func on_room_changed(room):
	if current_room == null:
		set_camera_limits(room.get_node("CollisionShape2D"))
		reset_smoothing()
	elif room != current_room:
		set_camera_limits(room.get_node("CollisionShape2D"))
		
		if Global.do_room_pause:
			get_tree().paused = true
			PhysicsServer2D.set_active(true)
			await get_tree().create_timer(0.69).timeout
			reset_smoothing()
		for p in get_tree().get_nodes_in_group("projectile"):
			if is_instance_valid(p):
				p.queue_free()
		get_tree().paused = false
		reset_smoothing()
		current_room.exit()
	
	current_room = room

func set_limits(limit_type, limit_pos):
	if limit_type == 0: # let cam go left
		limit_right = limit_pos
	elif limit_type == 1: # let cam go right
		limit_left = limit_pos
		limit_left = limit_pos
	elif limit_type == 2: # above
		limit_bottom = limit_pos
	elif limit_type == 3: #below
		limit_top = limit_pos
