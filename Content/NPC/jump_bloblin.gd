extends CharacterBody2D

const SPEED = 300.0
@export var JUMP_VELOCITY = -100.0

var jump_count = 0
@export var hp = 2

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	velocity.y = JUMP_VELOCITY
	$JumpTimer.start()

func _physics_process(delta):
	var dir = Global.get_player_dir(global_position)
	if dir:
		$Sprite2D.scale.x = -dir
	velocity.x *= 0.7
	velocity.y += gravity * delta
	move_and_slide()
	if velocity.y < 0:
		$Sprite2D.frame = 0
	else:
		$Sprite2D.frame = 1


func _on_rx_hitbox_damage_received(amount, damage_source):
	if damage_source.is_in_group("player_attack"):
		hp -= amount
		if hp == 0:
			queue_free()
		else:
			var kb_dir = sign(global_position.x - damage_source.get_parent().global_position.x)
			velocity = Vector2(kb_dir*100, -30)
			$RxHitbox.do_iframes()
			modulate.a = 0.5
			await $RxHitbox.i_timer.timeout
			modulate.a = 1


func _on_jump_timer_timeout():
	if is_on_floor():
		jump_count = (jump_count + 1) % 2
		if jump_count == 0:
			velocity.y = JUMP_VELOCITY
		else:
			velocity.y = JUMP_VELOCITY / 2
