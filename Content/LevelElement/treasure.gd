extends Sprite2D
@export var value = 9

@onready var money = preload("res://Content/Util/truffy_generator.tscn")

func _on_rx_hitbox_damage_received(_amount, _damage_source):
	Global.do_freeze_frames()
	var money_instance = money.instantiate()
	add_child(money_instance)
	$RxHitbox.set_deferred("monitorable", false)
	frame_coords.x = 1
