extends State

@onready var bonk_scene = preload("res://Content/Player/bonk_effect.tscn")

func enter():
	target.get_node("Anim").custom_play("pogo")
	target.get_node("PogoTxHitbox").set_deferred("monitoring", true)
	target.get_node("PogoTxHitbox").modulate = Color(1,1,1)

func update(delta):
	if !target.has_jump_ended && !Input.is_action_pressed("jump") && target.velocity.y < 0:
		target.velocity.y /= 1.5
		target.has_jump_ended = true
	target.move(delta)

func exit():
	target.get_node("PogoTxHitbox").set_deferred("monitoring", false)
	target.get_node("PogoTxHitbox").modulate = Color(0,0,0)

func try_transition() -> State:
	if transitions.is_grounded():
		return get_node("../Ground")
	if !transitions.is_pogo():
		return get_node("../Fall")
	return null


func _on_pogo_tx_hitbox_body_entered(body):
	if Input.is_action_pressed("jump"):
		target.velocity.y = min(target.velocity.y, -140)
	else:
		target.velocity.y = min(target.velocity.y, -80)
	
	if body and body.is_in_group("bonker"):
		var bonk = bonk_scene.instantiate()
		bonk.global_position = target.global_position + Vector2(0,9)
		target.get_parent().add_child(bonk)
	
	# Reset hitbox
	exit()
	await get_tree().physics_frame
	if SM.current_state == self:
		enter()

func _on_pogo_tx_hitbox_area_entered(area):
	_on_pogo_tx_hitbox_body_entered(null)
