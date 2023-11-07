extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if !visible and !get_tree().paused:
			visible = true
			get_tree().paused = true
		elif visible:
			visible = false
			get_tree().paused = false
