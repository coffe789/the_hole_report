extends CharacterBody2D
class_name Truffy

const denominations = [10, 5, 1]

var value : int = 1 : set = set_value

func set_value(v : int) -> void:
	value = v
	if value not in denominations:
		push_warning(
			"TRUFFY WAS SPAWNED WITH INVALID DENOMINATION. WHATS EVEN THE POINT"
		)
	else:
		var d_count = denominations.size()
		for i in d_count:
			if value == denominations[d_count - i - 1]:
				$Sprite2D.frame_coords.y = i

func randomise_velocity() -> void:
	var r = deg_to_rad(randf_range(0,360))
	var v = Vector2(0.0, randf_range(min_explosion_speed, max_explosion_speed))
	v = v.rotated(r)
	v.y *= 0.6
	v.y = -abs(v.y)
	velocity = v

var target
const min_explosion_speed = 40.0
const max_explosion_speed = 100.0
const truffy_friction = 100.0
const truffy_acceleration = 60.0
const truffy_gravity = 40.0
const truffy_max_zoominocity = 250.0

func _on_seek_range_entered(body: Node2D) -> void:
	if body.is_in_group("can_collect_truffies"):
		# The player is allowed to overrite any NPC taking the Truffies
		if target == null or body.is_in_group("player"):
			target = body

func _physics_process(delta: float) -> void:
	
	if target:
		set_collision_layer_value(1, false)
		
		var diff = target.global_position - global_position
		
		velocity += diff * truffy_acceleration * delta
	
	else:
		if is_on_floor():
			velocity.y = 1
		else:
			velocity.y += truffy_gravity * delta
	
	if abs(velocity.x) > 1:
		velocity.x -= truffy_friction * delta * sign(velocity.x)
	else:
		velocity.x = 0
	
	if velocity.length() > truffy_max_zoominocity:
		velocity = velocity.normalized() * truffy_max_zoominocity
	
	move_and_slide()

func _on_collect_range_body_entered(body):
	Global.add_money(value)
	queue_free()
