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
	$RxHitbox.i_timer.timeout.connect(func reset_alpha(): modulate.a = 1)
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
	if Input.is_action_just_pressed("attack"):
		if !is_attacking:
			$Anim.custom_play("attack")
			$AttackTimer.start()
			is_attacking = true
			await $AttackTimer.timeout
			is_attacking = false
	var dir = Input.get_axis("ui_left", "ui_right")
	if dir && !is_attacking:
		$Sprite2D.scale.x = sign(dir)
		$TxHitbox.position.x = 10 * sign(dir)

func _on_rx_hitbox_damage_received(amount, damage_source):
	if damage_source.is_in_group("enemy_attack"):
		hp -= amount

func set_health(new_amount):
	Global.update_hearts(new_amount)
	if new_amount <= 0:
		die()
		return false
	if new_amount < hp:
		$SM.transition_state($SM/States/Fall)
		$RxHitbox.do_iframes()
		modulate.a = 0.5
		
		velocity = Vector2(-sign($Sprite2D.scale.x) * 300, -80)
		Global.do_freeze_frames(0.1)
	hp = new_amount
	return true

func spike_respawn():
	if set_health(hp - 1):
		velocity = Vector2.ZERO
		global_position = Global.spike_respawn_pos
		$SM.transition_state($SM/States/Fall)
		$Anim.play("idle")
		

func die():
	visible = false
	await Global.death_wipe()
	set_health(MAX_HP)
	velocity = Vector2.ZERO
	global_position = Global.death_respawn_pos
	$SM.transition_state($SM/States/Fall)
	$Anim.play("idle")
	visible = true


func _on_spike_detect_body_entered(body):
	spike_respawn()
