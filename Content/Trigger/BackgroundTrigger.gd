extends Trigger

@onready var bg = Global.get_unique("bg")
@export var from_char = "A"
@export var to_char = "B"

func activate():
	set_position_ratio()
	var alpha = lerp_from_position(0, 1)
	bg.get_node("ParallaxLayer/bg" + from_char).modulate.a = 1 - alpha
	bg.get_node("ParallaxLayer2/bg" + from_char).modulate.a = 1 - alpha
	bg.get_node("ParallaxLayer3/bg" + from_char).modulate.a = 1 - alpha
	
	bg.get_node("ParallaxLayer/bg" + to_char).modulate.a = alpha
	bg.get_node("ParallaxLayer2/bg" + to_char).modulate.a = alpha
	bg.get_node("ParallaxLayer3/bg" + to_char).modulate.a = alpha
