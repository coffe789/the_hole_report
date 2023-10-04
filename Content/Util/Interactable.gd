extends Node2D
signal interact

func _on_body_entered(body):
	if body.is_in_group("player") and body.visible:
		$dir.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		$dir.visible = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_up") and $dir.visible:
		emit_signal("interact")
