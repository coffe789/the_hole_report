extends State

func enter():
	target.has_jump_ended = false
	target.velocity.y = target.JUMP_SPEED
	target.get_node("Anim").custom_play("jump")
	target.get_node("PrejumpTimer").stop()
	target.get_node("CoyoteTimer").stop()
#	print(target.velocity.y)

func update(delta):
	if !target.has_jump_ended && !Input.is_action_pressed("jump") && target.velocity.y < 0:
		target.velocity.y /= 3
		target.has_jump_ended = true
	target.move(delta)

func exit():
	pass

func try_transition() -> State:
	if transitions.is_grounded():
		return get_node("../Ground")
	if transitions.is_pogo():
		return get_node("../Pogo")
	if transitions.is_fall():
		return get_node("../Fall")
	return null
