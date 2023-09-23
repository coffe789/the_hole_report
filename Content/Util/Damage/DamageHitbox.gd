extends Area2D
class_name DamageHitbox

signal damage_anything(amount, damage_source)
signal target_found(target)

@onready var collision_shape = $CollisionShape2D
@export var damage_amount = 1
var damage_source = self

func _ready():
	connect("area_entered", _on_DamageHitbox_area_entered)
	connect("area_exited", _on_DamageHitbox_area_exited)

func disable():
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

func enable():
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)


func _physics_process(_delta):
	# Signal is received by connected hurtboxes, or if parent wants to know fsr
	emit_signal("damage_anything", damage_amount, damage_source)


func _on_DamageHitbox_area_entered(area):
	if area is DamageHurtbox:
		connect("damage_anything", area._on_DamageHitbox_entered)
		emit_signal("damage_anything", damage_amount, damage_source)
		emit_signal("target_found", area)

func _on_DamageHitbox_area_exited(area):
	if area is DamageHurtbox:
		disconnect("damage_anything", area._on_DamageHitbox_entered)
