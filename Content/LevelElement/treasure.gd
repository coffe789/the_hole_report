extends Sprite2D
@export var value = 9

@onready var money = preload("res://Content/Util/truffy_generator.tscn")
@export var hp = 2

func _on_rx_hitbox_damage_received(_amount, damage_source):
	if !damage_source.is_in_group("player_attack"):
		return
		
	Global.do_freeze_frames()
	var money_instance = money.instantiate()
	hp -= 1
	
	if hp <= 0:
		$RxHitbox.set_deferred("monitorable", false)
		frame_coords.x = 1
		money_instance.value = value
	else:
		money_instance.value = 3
		$RxHitbox.do_iframes()
	
	add_child(money_instance)
	money_instance.position.x = 8
