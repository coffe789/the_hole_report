extends State

func enter():
	target.velocity.x = 0
	target.get_node("Web").visible = true

func update(delta):
	target.velocity.y = move_toward(target.velocity.y, -200, delta * 80)
	target.move_and_slide()

func exit():
	target.get_node("Web").visible = false

func try_transition() -> State:
	if transitions.is_at_start_height():
		return target.get_node("SM/States/Wander")
	return null
