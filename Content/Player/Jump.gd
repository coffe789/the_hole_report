extends State

var has_ended_jump

func enter():
	has_ended_jump = false
	target.velocity.y = target.JUMP_SPEED
	target.get_node("Anim").play("jump")
	target.get_node("PrejumpTimer").stop()

func update(delta):
	if !has_ended_jump && !Input.is_action_pressed("jump") && target.velocity.y < 0:
		target.velocity.y /= 3
		has_ended_jump = true
	target.move(delta)

func exit():
	pass

func try_transition() -> State:
	if transitions.is_grounded():
		return get_node("../Ground")
	if transitions.is_fall():
		return get_node("../Fall")
	return null
