@tool

extends Area2D
@export var is_bounce_left = true:
	set(value):
		is_bounce_left = value
		for g in get_groups(): remove_from_group(g)
		for g in $RxHitbox.get_groups(): $RxHitbox.remove_from_group(g)
		if value == true:
			scale.x = 1
			add_to_group("side_shroom_l")
			$RxHitbox.add_to_group("shroom_box_l")
		else:
			scale.x = -1
			add_to_group("side_shroom_r")
			$RxHitbox.add_to_group("shroom_box_r")
