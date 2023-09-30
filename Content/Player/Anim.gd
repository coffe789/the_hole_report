extends AnimationPlayer

func custom_play(_name: StringName = "", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false):
	if get_parent().is_attacking:
		pass#animation_set_next(current_animation, name)
	else:
		play(_name, custom_blend, custom_speed, from_end)
