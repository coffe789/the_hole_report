@tool
extends Trigger
@export_enum("FOR_SPIKES", "FOR_DEATH", "FOR_BOTH") var type = "FOR_DEATH"

func _ready():
	super()
	if !get_tree().debug_collisions_hint || Engine.is_editor_hint():
		$ColorRect.visible = false

func activate():
	if type == "FOR_SPIKES" || type == "FOR_BOTH":
		Global.spike_respawn_pos = $ColorRect.global_position
		Global.spike_respawn_pos.y -= 5
	if type == "FOR_DEATH" || type == "FOR_BOTH":
		Global.death_respawn_pos = $ColorRect.global_position
		Global.death_respawn_pos.y -= 5
