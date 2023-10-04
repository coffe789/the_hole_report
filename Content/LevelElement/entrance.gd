extends Node2D
@export var target : Node2D
@export var no_smoothing = true

func _on_interactable_interact():
	var p: CharacterBody2D = Global.get_unique("player")
	var cam: Camera2D = Global.get_unique("camera")
	if p && cam:
		Global.do_room_pause = false
		p.global_position = target.global_position
		p.global_position.y -= 6
		await get_tree().physics_frame
		await get_tree().physics_frame
		if no_smoothing:
			cam.reset_smoothing()
		Global.do_room_pause = true
