extends State

func enter():
	pass

func update(delta):
	target.move(delta)
	
	if target.velocity.y > 50:
		target.get_node("Anim").custom_play("fall")
	else:
		target.get_node("Anim").custom_play("idle")

func exit():
	pass

func try_transition() -> State:
#	if transitions.is_jump():
#		return get_node("../Jump")
	if transitions.is_grounded():
		return get_node("../Ground")
	if transitions.is_pogo():
		return get_node("../Pogo")
	return null
