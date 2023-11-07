extends CanvasLayer
var idx = 0
@export var autostart = true

# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	if autostart: start()

func _input(_event):
	if visible and Input.is_action_just_pressed("ui_accept"):
		next()

func start():
	get_tree().paused = true
	visible = true
	$RichTextLabel.text = $Dialogue.dialogue[idx]

func next():
	idx += 1
	if idx > $Dialogue.dialogue.size() - 1:
		await get_tree().physics_frame
		await get_tree().physics_frame
		get_tree().paused = false
		queue_free()
	else:
		$RichTextLabel.text = $Dialogue.dialogue[idx]
