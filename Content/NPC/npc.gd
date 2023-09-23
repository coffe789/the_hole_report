extends Sprite2D

@export var dialogue_offset = Vector2(-16, -24)
@onready var tb_scene = preload("res://Content/UI/textbox.tscn")
var dialogues: Array[Dialogue]= []

# Called when the node enters the scene tree for the first time.
func _ready():
	$Interactable.connect("interact", on_interact)
	for c in get_children():
		if c is Dialogue:
			dialogues.append(c)

func on_interact():
	if get_tree().paused: return
	$Interactable.visible = false
	
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
	if dialogues[idx].is_player:
		var p = Global.get_unique("player")
		add_child.call_deferred(tb)
		if p:tb.offset = p.global_position-global_position + dialogue_offset
		print(p.global_position-global_position)
	else:
		add_child.call_deferred(tb)
		tb.offset = dialogue_offset
	tb.dialogue = dialogues[idx].dialogue
	idx += 1
	return tb

func _process(delta):
	pass
