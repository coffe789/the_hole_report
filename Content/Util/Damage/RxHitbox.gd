extends Area2D
class_name RxHitbox
signal damage_received(amount, damage_source)

# invincibility timer
@export var i_seconds = .4
var i_timer = Timer.new()

var is_invincible = false

func _ready():
	i_timer.one_shot = true
	add_child(i_timer)

func do_iframes():
	i_timer.start(i_seconds)
	
	is_invincible = true
	await i_timer.timeout
	is_invincible = false

func _on_damaged(amount, damage_source):
	if !is_invincible and i_timer.time_left == 0 and i_timer.is_stopped():
		# Pass the signal on (to the parent/logic system)
		emit_signal("damage_received", amount, damage_source)
