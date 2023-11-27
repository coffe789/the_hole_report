extends Node

const TRANS = Tween.TRANS_SINE
const EASE = Tween.EASE_IN_OUT

var amplitude = 0
var priority = 0

@onready var camera = get_parent()
@onready var tween = get_tree().create_tween()

func start(duration = 0.2, frequency = 15, _amplitude = 16, _priority = 0):
	if (priority >= self.priority):
		self.priority = _priority
		self.amplitude = _amplitude

		$Duration.wait_time = duration
		$Frequency.wait_time = 1 / float(frequency)
		$Duration.start()
		$Frequency.start()

		_new_shake()

func _new_shake():
	var rand = Vector2()
	rand.x = randf_range(-amplitude, amplitude)
	rand.y = randf_range(-amplitude, amplitude)

	tween.interpolate_value(camera.offset, rand, $Frequency.wait_time, TRANS, EASE)
	tween.start()

func _reset():
	tween.interpolate_property(camera, "offset", camera.offset, Vector2(), $Frequency.wait_time, TRANS, EASE)
	tween.start()

	priority = 0


func _on_Frequency_timeout():
	_new_shake()


func _on_Duration_timeout():
	_reset()
	$Frequency.stop()
