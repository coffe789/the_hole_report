extends CharacterBody2D

@export var hp = 2
@export var value = 1

func _ready():
	global_rotation = 0

func _physics_process(_delta):
	var dir = Global.get_player_dir(global_position)
	if dir:
		$Sprite2D.scale.x = dir
	velocity *= 0.8
	move_and_slide()
	global_rotation = 0


func _on_rx_hitbox_damage_received(amount, damage_source):
	if damage_source.is_in_group("player_attack"):
		hp -= amount
		if hp == 0:
			Global.do_death_animation(global_position, 0.9, value)
			queue_free()
		else:
			var kb_dir = sign(global_position.x - damage_source.get_parent().global_position.x)
			velocity = Vector2(kb_dir*100, 0)
			$RxHitbox.do_iframes()
			modulate.a = 0.5
			await $RxHitbox.i_timer.timeout
			modulate.a = 1
