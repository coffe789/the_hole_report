extends TileMap
var start_pos

func _ready():
	start_pos = position
	await get_tree().physics_frame
	position = start_pos # I hate godot.
