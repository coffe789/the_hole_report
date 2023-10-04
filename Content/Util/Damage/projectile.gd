extends TxHitbox

@export var direction := Vector2.ZERO
@export var speed := 100.0
@export var lifetime := 10.0 # Seconds
@export var damage := 1
@export var from_player = false
var life_timer

func _ready():
	super()
	add_to_group("projectile")
	if from_player:
		add_to_group("player_attack")
	else:
		add_to_group("enemy_attack")
	
	life_timer = Timer.new()
	add_child(life_timer)
	life_timer.connect("timeout", queue_free)
	life_timer.start(lifetime)

func get_next_position(delta):
	return position + direction * delta * speed

func _physics_process(delta):
	var to = get_next_position(delta)
	$RayCast2D.target_position = (to - position)
	$RayCast2D.force_raycast_update()
	var col = $RayCast2D.get_collider()
	if col and col is TileMap:
		queue_free()
	else:
		position = to

func _on_area_exited(area):
	# Do not carry over between rooms
	if area.is_in_group("room"):
		queue_free()

func _on_area_entered(area):
	if area is RxHitbox:
		if from_player and area.get_parent().is_in_group("enemy"):
			queue_free()
		elif !from_player and area.get_parent().is_in_group("player"):
			add_to_group("enemy_attack")
