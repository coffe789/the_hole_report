extends State

func enter():
	target.get_node("Anim").stop()

func update(delta):
	target.move(delta)
	if Input.get_axis("ui_left", "ui_right") && target.get_node("Anim").current_animation != "walk":
		target.get_node("Anim").play("walk")
	elif Input.get_axis("ui_left", "ui_right") == 0:
		target.get_node("Anim").stop()
		target.get_node("Sprite2D").frame = 0

func exit():
	pass

func try_transition() -> State:
	if transitions.is_jump():
		return get_node("../Jump")
	if transitions.is_fall():
		return get_node("../Fall")
	return null
