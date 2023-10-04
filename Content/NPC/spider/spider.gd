extends CharacterBody2D

var facing = -1
var dangle_y
@export var hp = 3
@export var wander_speed = 30
@export var run_speed = 40

func _ready():
	$SM.init_machine(self, $SM/States/Wander)

func _physics_process(delta):
	$SM.update(delta)

func _on_walk_dectector_barrier_detected(type, direction):
	$Sprite2D.scale.x = direction
	facing = -direction

func _on_player_search_body_entered(body):
	if body.is_in_group("player") and $SM.current_state == $SM/States/Wander:
		$SM.transition_state($SM/States/Dangle)


func _on_rx_hitbox_damage_received(amount, damage_source):
	if damage_source.is_in_group("player_attack"):
		hp -= 1
		if hp == 0:
			queue_free()
		else:
			$SM.transition_state($SM/States/PissedOff)
			$RxHitbox.do_iframes()
			modulate.a = 0.5
			await $RxHitbox.i_timer.timeout
			modulate.a = 1
