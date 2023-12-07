extends StaticBody2D

func _on_rx_hitbox_damage_received(amount, damage_source):
	if damage_source.is_in_group("pogo"):
		queue_free()
