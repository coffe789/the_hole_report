extends State
const JUMP_SPEED = 100
const GRAVITY = 200

func _ready():
	randomize()

func enter():
	var p = Global.get_unique("player")
	if p:
		var dir = sign(p.global_position.x - target.global_position.x)
		target.velocity.x = dir * target.run_speed
		target.velocity.y = -JUMP_SPEED

func update(delta):
	if target.is_on_floor():
		var p = Global.get_unique("player")
		if p:
			var dir = sign(p.global_position.x - target.global_position.x)
			if randi_range(0,3) == 0: dir *= -1
			target.velocity.x = dir * target.run_speed
			target.velocity.y = -JUMP_SPEED
	
	target.velocity.y = move_toward(target.velocity.y, 200, delta * GRAVITY)
	target.move_and_slide()

func exit():
	pass
