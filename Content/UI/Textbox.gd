extends ColorRect
signal done

const LINE_HEIGHT = 18
const CHAR_TIME = 0.03

enum AppendStatus {
	NORMAL,
	PUNCTUATION,
	DONE,
}

@export var dialogue: Array[String] = ["hi"]
var is_upside_down = false
var d_index = 0
var offset = Vector2.ZERO

func _ready():
	$Timer.start(CHAR_TIME)
	$Timer.connect("timeout", update)
	position.x += offset.x
	reset()
	
	if is_upside_down:
		$Tail.scale.y = -1

func update():
	var status = append_new_letter()
	match status:
		AppendStatus.NORMAL:
			$Timer.start(CHAR_TIME)
		AppendStatus.PUNCTUATION:
			$Timer.start(CHAR_TIME * 6)
		AppendStatus.DONE:
			d_index += 1

func reset():
	$RichTextLabel.visible_characters = -1
	$RichTextLabel.text = dialogue[d_index]
	if is_upside_down:
		position.y = offset.y
	else:
		position.y = offset.y - (LINE_HEIGHT * $RichTextLabel.get_line_count() - 1)/2
	size.y = LINE_HEIGHT * $RichTextLabel.get_line_count() + $RichTextLabel.position.y
	if !is_upside_down: $Tail.position.y = size.y
	$RichTextLabel.visible_characters = 0

func append_new_letter():
	if $RichTextLabel.visible_characters < dialogue[d_index].length():
		var this_char = dialogue[d_index][$RichTextLabel.visible_characters]
#		label.text += this_char
		$RichTextLabel.visible_characters += 1
		if $RichTextLabel.visible_characters >= dialogue[d_index].length():
			return AppendStatus.DONE
		if (this_char == '.' or this_char == '?' or this_char == '!' or this_char == ','):
			return AppendStatus.PUNCTUATION
		else:
			return AppendStatus.NORMAL
	return AppendStatus.DONE

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if d_index > dialogue.size() - 1:
			await get_tree().physics_frame
			await get_tree().physics_frame
			emit_signal("done")
			queue_free()
		elif $RichTextLabel.visible_characters < $RichTextLabel.text.length():
			$RichTextLabel.visible_characters = $RichTextLabel.text.length()
		else:
			reset()
			$Timer.start(CHAR_TIME)
