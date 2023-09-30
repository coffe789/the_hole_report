extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if !visible:
			visible = true
			get_tree().paused = true
		else:
			visible = false
			get_tree().paused = false
