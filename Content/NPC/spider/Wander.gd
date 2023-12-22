extends State

func enter():
	target.velocity.y = 0

func update(delta):
	target.velocity.x = move_toward(target.velocity.x, target.facing * 30, delta * 30)
	target.move_and_slide()

func exit():
	pass
