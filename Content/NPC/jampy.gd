extends CharacterBody2D

@onready var projectile = preload("res://Content/Util/Damage/projectile.tscn")
const JUMP_VELOCITY = -70.0
var gravity = 1.5
var hp = 2
var facing = -1

func _ready():
	$ShootTimer.start() # Autostart doesn't work

func set_facing():
	var p = Global.get_unique("player")
	if p:
		var dir = sign(p.global_position.x - global_position.x)
		if dir != 0:
			facing = dir
			$Sprite2D.flip_h = (facing == 1)

func _physics_process(delta):
	velocity.y += gravity
	if Input.is_action_just_pressed("jump"):
		$PrejumpTimer.start()
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
	elif $PrejumpTimer.time_left > 0 && is_on_floor():
		velocity.y = JUMP_VELOCITY
	velocity.x *= 0.7
	move_and_slide()
	set_facing()
	if velocity.y < 0:
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0

func _on_rx_hitbox_damage_received(amount, damage_source):
	if damage_source.is_in_group("player_attack"):
		hp -= amount
		if hp == 0:
			Global.do_death_animation(global_position, 0.9, 4)
			queue_free()
		else:
			var kb_dir = sign(global_position.x - damage_source.get_parent().global_position.x)
			velocity = Vector2(kb_dir*100, -20)
			$RxHitbox.do_iframes()
			modulate.a = 0.5
			await $RxHitbox.i_timer.timeout
			modulate.a = 1

func _on_timer_timeout():
	var p_instance = projectile.instantiate()
	p_instance.direction.x = facing
	get_tree().root.add_child(p_instance)
	p_instance.global_position = global_position
