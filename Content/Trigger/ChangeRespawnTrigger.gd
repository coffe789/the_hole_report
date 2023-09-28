@tool
extends Trigger

func _ready():
	super()
	if !Engine.is_editor_hint():
		$ColorRect.visible = false

func activate():
	Global.spike_respawn_pos = global_position
	Global.spike_respawn_pos.y -= 5
