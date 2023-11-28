extends CharacterBody2D

const MAX_HP = 6
const INPUT_ACCEL = 30.0 * 60.0
const JUMP_SPEED = -150.0
var max_speed = Vector2(75, 200)
var gravity = 400

var accel = Vector2.ZERO
var is_attacking = false
@export var hp = MAX_HP : set=set_health
var has_jump_ended = false

func _ready():
	$RxHitbox.i_timer.timeout.connect(func reset_alpha(): modulate.a = 1)
	$SM.init_machine(self, $SM/States/Ground)

func move(delta):
	var dir = Input.get_axis("ui_left", "ui_right")
	if !is_on_floor(): dir *= pow(modulate.a, 2) # Less control when taking damage
	accel = Vector2(dir * INPUT_ACCEL, gravity)
	velocity += accel * delta
	if is_on_floor():
		velocity.x *= 0.7
	else:
		velocity.x *= 0.9
		
	velocity.x = clampf(velocity.x, -max_speed.x, max_speed.x)
	velocity.y = clampf(velocity.y, -INF, max_speed.y)
	
	move_and_slide()
	
	if Input.is_action_just_pressed("ui_down") and is_on_floor()\
	 and !$FallthruDetectL.is_colliding() and !$FallthruDetectR.is_colliding():
		position.y += 3
	
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
		$TxHitbox.position.x = 9 * sign(dir)

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
	hp = min(new_amount, MAX_HP)
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


func _on_spike_detect_body_entered(_body):
	spike_respawn()


func _on_water_finder_body_entered(_body):
	gravity = 200
	max_speed.y = 50


func _on_water_finder_body_exited(_body):
	gravity = 400
	max_speed.y = 200


func _on_tx_hitbox_target_found(target):
	if not target.is_in_group("player_rxbox") and not target.get_parent().is_in_group("projectile"):
		velocity.x = -sign($Sprite2D.scale.x) * 150
