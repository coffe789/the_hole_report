extends CharacterBody2D


@export var speed = 33.0
const JUMP_VELOCITY = -400.0
@export var facing = 1
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var hp = 2

func _physics_process(delta):
	if facing:
		$Sprite2D.scale.x = -facing
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if facing:
		velocity.x = facing * speed
	move_and_slide()


func _on_walk_dectector_barrier_detected(_type, direction):
	facing = -direction


func _on_rx_hitbox_damage_received(amount, damage_source):
	if damage_source.is_in_group("player_attack"):
		hp -= amount
		speed += 10
		if hp == 0:
			queue_free()
		else:
			var kb_dir = sign(global_position.x - damage_source.get_parent().global_position.x)
			velocity = Vector2(kb_dir*100, -30)
			facing = 0
			$StunTimer.start()
			$RxHitbox.do_iframes()
			modulate.a = 0.5
			await $StunTimer.timeout
			facing = -$Sprite2D.scale.x
			await $RxHitbox.i_timer.timeout
			modulate.a = 1
