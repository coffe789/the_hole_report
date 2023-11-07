extends Sprite2D

func _on_interactable_interact():
	Global.get_unique("player").set_health(3)
	Global.death_respawn_pos = global_position
	Global.death_respawn_pos.y -= 9
	Global.death_respawn_pos.x -= 4
