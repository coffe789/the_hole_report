extends State

func enter():
	pass#target.get_node("GPUParticles2D").emitting = true

func update(delta):
	target.move(delta)
	target.get_node("CoyoteTimer").start()
	if Input.get_axis("ui_left", "ui_right") && target.get_node("Anim").current_animation != "walk":
		target.get_node("Anim").custom_play("walk")
	elif Input.get_axis("ui_left", "ui_right") == 0:
		target.get_node("Anim").custom_play("idle")

func exit():
	pass

func try_transition() -> State:
	if transitions.is_jump():
		return get_node("../Jump")
	if transitions.is_fall():
		return get_node("../Fall")
	if transitions.is_grounded():
		return get_node("../Ground")
	if transitions.is_pogo():
		return get_node("../Pogo")
	return null
