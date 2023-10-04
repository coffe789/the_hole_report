@tool
extends TileMap
enum rot {
	T_LEFT,
	T_RIGHT,
	B_RIGHT,
	B_LEFT,
}
enum d {FORWARD = 1, BACKWARD = -1}

@export var square_size = Vector2(64, 64)
@export var corner := rot.T_LEFT
@export var dir := d.FORWARD
@export var max_speed = 50
@export var accel = 10

var start_pos : Vector2
var offset : Vector2
var to_point : Vector2
var points := []
var speed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.is_editor_hint() && Global.is_map_ready:
		start_pos = position
		await get_tree().physics_frame
		position = start_pos # I hate godot
		points = [
			Vector2(0,0),
			Vector2(square_size.x, 0),
			Vector2(square_size.x, square_size.y),
			Vector2(0, square_size.y),
		]
		offset = points[corner]
		corner = ((corner + dir) + 4) % 4
		to_point = points[corner]

func _draw():
	if Engine.is_editor_hint():
		var rect = square_size
		if corner == 1 or corner == 2: rect.x *= -1
		if corner == 2 or corner == 3: rect.y *= -1
		draw_rect(Rect2(Vector2.ZERO, rect), Color(1,1,1, 0.9), false, 2)

func _process(delta):
	if Engine.is_editor_hint():
		queue_redraw()

func _physics_process(delta):
	if !Engine.is_editor_hint():
		if position == start_pos + to_point - offset:
			corner = ((corner + dir) + 4) % 4
			to_point = points[corner]
			speed = 0
		
		speed = min(speed + accel, max_speed)
		var tmp = Vector2.ZERO # I literally hate godot
		tmp.x = move_toward(position.x, start_pos.x + to_point.x - offset.x, speed * delta)
		tmp.y = move_toward(position.y, start_pos.y + to_point.y - offset.y, speed * delta)
		position = tmp
