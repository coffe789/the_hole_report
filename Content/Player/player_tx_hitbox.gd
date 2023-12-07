extends TxHitbox

func _on_body_entered(body):
	if body.is_in_group("breakable_tile"):
		body.queue_free()
