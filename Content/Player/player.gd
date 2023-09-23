extends CharacterBody2D

const MAX_SPEED = Vector2(65, 200)
const INPUT_ACCEL = 30.0 * 60.0
const JUMP_SPEED = -205.0
const GRAVITY = 400

var accel = Vector2.ZERO

func _ready():
	$SM.init_machine(self, $SM/States/Ground)

func move(delta):
	var dir = Input.get_axis("ui_left", "ui_right")
	accel = Vector2(dir * INPUT_ACCEL, GRAVITY)
	velocity += accel * delta
	if is_on_floor():
		velocity *= 0.7
	else:
		velocity.x *= 0.9
		
	velocity.x = clampf(velocity.x, -MAX_SPEED.x, MAX_SPEED.x)
	velocity.y = clampf(velocity.y, -MAX_SPEED.y, MAX_SPEED.y)
	
	move_and_slide()

func _physics_process(delta):
	if Input.is_action_just_pressed("jump"):
		$PrejumpTimer.start()
	$SM.update(delta)
	if velocity.x:
		$Sprite2D.scale.x = sign(velocity.x)
