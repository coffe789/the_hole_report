extends Node
var target

func is_see_ground():
	return target.get_node("VRay").get_collider() != null or target.get_node("VRay2").get_collider() != null

func is_at_start_height():
	return target.global_position.y <= target.dangle_y
