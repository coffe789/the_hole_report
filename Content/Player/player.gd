extends CharacterBody2D

const MAX_SPEED = Vector2(65, 200)
const MAX_HP = 3
const INPUT_ACCEL = 30.0 * 60.0
const JUMP_SPEED = -205.0
const GRAVITY = 400

var accel = Vector2.ZERO
var is_attacking = false
var hp = MAX_HP : set=set_health

func _ready():
	$SM.init_machine(self, $SM/States/Ground)

func move(delta):
	var dir = Input.get_axis("ui_left", "ui_right")
	if !is_on_floor(): dir *= pow(modulate.a, 2) # Less control when taking damage
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
	if Input.is_action_just_pressed("ui_down"):
		if !is_attacking:
			$Anim.custom_play("attack")
			$AttackTimer.start()
			is_attacking = true
			await $AttackTimer.timeout
			is_attacking = false
	var dir = Input.get_axis("ui_left", "ui_right")
	if dir && !is_attacking:
		$Sprite2D.scale.x = sign(dir)
		$TxHitbox.position.x = 5 * sign(dir)


func _on_rx_hitbox_damage_received(amount, damage_source):
	if damage_source.is_in_group("enemy_attack"):
		hp -= amount
#		var new_health = current_health - amount
#		Global.update_player_health.emit(new_health)
#		Global.update_health_ui.emit(current_health)
		await $RxHitbox.i_timer.timeout
		modulate.a = 1

func set_health(new_amount):
	if new_amount < hp:
		$SM.transition_state($SM/States/Fall)
		$RxHitbox.do_iframes()
		modulate.a = 0.5
		
		velocity = Vector2(-sign($Sprite2D.scale.x) * 300, -80)
		Global.do_freeze_frames(0.1)
	if new_amount <= 0:
#		die()
		new_amount = 4
