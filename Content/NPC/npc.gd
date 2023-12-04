extends Sprite2D

@export var dialogue_offset = Vector2(-16, -14)
@export var player_dialogue_offset = Vector2(-16, -14)
@export var is_dialogue_below = false
@onready var tb_scene = preload("res://Content/UI/textbox.tscn")
var dialogues: Array[Dialogue]= []

func _ready():
	$Interactable.connect("interact", on_interact)
	for c in get_children():
		if c is Dialogue:
			dialogues.append(c)

func on_interact():
	var p = Global.get_unique("player")
	if !get_tree().paused && p.is_on_floor():
		$Interactable.visible = false
		p.velocity = Vector2.ZERO
	
		get_tree().paused = true
		for d in dialogues:
			var tb = next_dialogue()
			await tb.done
		idx = 0

		get_tree().paused = false
		$Interactable.visible = true

var idx = 0
func next_dialogue():
	var tb = tb_scene.instantiate()
	tb.is_upside_down = is_dialogue_below
	if dialogues[idx].is_player:
		var p = Global.get_unique("player")
		add_child.call_deferred(tb)
		if p:tb.offset = p.global_position-global_position + player_dialogue_offset
	else:
		add_child.call_deferred(tb)
		tb.offset = dialogue_offset
	tb.dialogue = dialogues[idx].dialogue
	idx += 1
	return tb
