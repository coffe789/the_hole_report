extends State

func enter():
	pass

func update(delta):
	target.move(delta)
	
	if target.velocity.y > 50:
		target.get_node("Anim").play("fall")
	else:
		target.get_node("Anim").stop()
		target.get_node("Sprite2D").frame = 0

func exit():
	pass

func try_transition() -> State:
	if transitions.is_grounded():
		return get_node("../Ground")
	return null
