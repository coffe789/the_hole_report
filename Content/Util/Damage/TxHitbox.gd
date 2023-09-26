extends Area2D
class_name TxHitbox

signal damage_anything(amount, damage_source)
signal target_found(target)

@export var damage_amount = 1
@export var damage_source:Node = self

func _ready():
	connect("area_entered", _on_TxHitbox_area_entered)
	connect("area_exited", _on_TxHitbox_area_exited)

func disable():
	set_deferred("monitoring", false)

func enable():
	set_deferred("monitoring", true)

func _physics_process(_delta):
	# Signal is received by connected hurtboxes
	emit_signal("damage_anything", damage_amount, damage_source)

func _on_TxHitbox_area_entered(area):
	if area is RxHitbox:
		connect("damage_anything", area._on_damaged)
		emit_signal("damage_anything", damage_amount, damage_source)
		emit_signal("target_found", area)

func _on_TxHitbox_area_exited(area):
	if area is RxHitbox:
		disconnect("damage_anything", area._on_damaged)
