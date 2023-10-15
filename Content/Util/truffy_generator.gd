extends Node2D

var value : int = 17

func _ready() -> void:
	generate_truffies.call_deferred()

@onready var t = preload("./truffy.tscn")
func generate_truffies(amount : int = value) -> void:
	var remaining_value_to_spawn : int = amount
	
	while remaining_value_to_spawn > 0:
		
		var truffy = t.instantiate()
		get_tree().root.add_child(truffy)
		
		for d in Truffy.denominations:
			if d <= remaining_value_to_spawn:
				truffy.value = d
				remaining_value_to_spawn -= d
				break
		
		truffy.global_position = global_position
		
		truffy.randomise_velocity()
	queue_free()


#func _on_timer_timeout() -> void:
#	generate_truffies(value)
#	queue_free()

#func _on_child_exiting_tree(x: Node) -> void:
#	if get_children().size() == 0:
#		await get_tree().create_timer(5.0).timeout
#		queue_free()
