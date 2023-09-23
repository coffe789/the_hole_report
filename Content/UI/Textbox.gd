extends ColorRect
signal done

const LINE_HEIGHT = 21
const CHAR_TIME = 0.03

enum AppendStatus {
	NORMAL,
	PUNCTUATION,
	DONE,
}

@export var dialogue: Array[String] = ["hi"]
var d_index = 0
var offset = Vector2.ZERO

func _ready():
	$Timer.start(CHAR_TIME)
	$Timer.connect("timeout", update)
	position.x += offset.x
	reset()

func update():
	var status = append_new_letter()
	match status:
		AppendStatus.NORMAL:
			$Timer.start(CHAR_TIME)
		AppendStatus.PUNCTUATION:
			$Timer.start(CHAR_TIME * 5)
		AppendStatus.DONE:
			d_index += 1

func reset():
	$RichTextLabel.text = dialogue[d_index]
	position.y = offset.y - (LINE_HEIGHT * $RichTextLabel.get_line_count() - 1)/2
	size.y = LINE_HEIGHT * $RichTextLabel.get_line_count() + $RichTextLabel.position.y
	$Tail.position.y = size.y
	$RichTextLabel.text = ""

func append_new_letter():
	var label = $RichTextLabel
	if label.text.length() < dialogue[d_index].length():
		var this_char = dialogue[d_index][label.text.length()]
		label.text += this_char
		if label.text.length() == dialogue[d_index].length():
			return AppendStatus.DONE
		if (this_char == '.' or this_char == '?' or this_char == '!' or this_char == ','):
			return AppendStatus.PUNCTUATION
		else:
			return AppendStatus.NORMAL
	return AppendStatus.DONE

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if d_index > dialogue.size() - 1:
			emit_signal("done")
			queue_free()
		elif $RichTextLabel.text.length() < dialogue[d_index].length():
			$RichTextLabel.text = dialogue[d_index]
		else:
			reset()
			$Timer.start(CHAR_TIME)
