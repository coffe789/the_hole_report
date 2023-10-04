extends Node
var target

func is_jump():
	return (
		(target.get_node("PrejumpTimer").time_left > 0 || Input.is_action_just_pressed("jump"))
		&& (target.is_on_floor() || target.get_node("CoyoteTimer").time_left > 0)
	)

func is_grounded():
	return target.is_on_floor()

func is_fall():
	return target.velocity.y > 0
