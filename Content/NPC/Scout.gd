extends Sprite2D

var idx = 0
var is_player_inside = false

enum {
	normal, left, right, up, down, yay
}

var code = [up, down, left, right, left, up]

func _on_interactable_interact():
	pass

func increment_idx():
	idx += 1
	$Interactable/dir.frame = idx
	frame = code[idx]

	# Code completed
	if idx == len(code) - 1:
		$Interactable.visible = false
		$AnimationPlayer.play("dance")
		await $AnimationPlayer.animation_finished
		$PogoTile.queue_free()

func _input(_event):
	if is_player_inside and idx < len(code) - 1:
		if Input.is_action_just_pressed("ui_up") and code[idx] == up:
			increment_idx()	
		elif Input.is_action_just_pressed("ui_down") and code[idx] == down:
			increment_idx()	
		elif Input.is_action_just_pressed("ui_left") and code[idx] == left:
			increment_idx()	
		elif Input.is_action_just_pressed("ui_right") and code[idx] == right:
			increment_idx()	

func _on_interactable_body_entered(body):
	if body.is_in_group("player"):
		is_player_inside = true

func _on_interactable_body_exited(body):
	if body.is_in_group("player"):
		is_player_inside = false
