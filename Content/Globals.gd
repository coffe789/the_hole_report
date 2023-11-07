extends Node

signal room_changed(room)

var is_map_ready = false
var money := 0
var death_respawn_pos = Vector2(100,100)
var spike_respawn_pos = Vector2(100,100)
var do_room_pause = true

func _ready():
	randomize()

func get_unique(group_name : String):
	return get_tree().get_nodes_in_group(group_name).pop_back()

func _input(event):
	if Engine.is_editor_hint():
		if event is InputEventMouseButton && event.button_index == 1 && !event.pressed:
			for room in get_tree().get_nodes_in_group("room"):
				room.get_node("CollisionShape2D").position = Vector2.ZERO

func get_player_dir(my_glob_pos: Vector2):
	var p = get_unique("player")
	if p:
		return sign(p.global_position.x - my_glob_pos.x)
	return 0

#func get_my_room(me:Node):
#	var p = me.get_parent()
#	while (p != null):
#		if p.is_in_group("room"):
#			return p
#		p = p.get_parent()
#	return null # Not in a room

func do_freeze_frames(freeze_time : float = 0.075):
	get_tree().paused = true
	await get_tree().create_timer(freeze_time).timeout
	get_tree().paused = false

func add_money(to_add):
	money += to_add
	$CanvasLayer/TopMenu/MoneyText.text = "x" + str(money)

func update_room_name(room_name:String):
	room_name = room_name.replace("_", " ")
	room_name = room_name.to_upper()
	$CanvasLayer/TopMenu/RoomText.text = "[right]" + room_name + "[/right]"

func update_hearts(hp):
	$CanvasLayer/TopMenu/H1.visible = hp >= 1
	$CanvasLayer/TopMenu/H2.visible = hp >= 2
	$CanvasLayer/TopMenu/H3.visible = hp >= 3

func death_wipe():
	$AnimationPlayer.play("death_wipe")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play_backwards("death_wipe")
	return $AnimationPlayer.animation_finished

@onready var truffy_scene = preload("res://Content/Util/truffy_generator.tscn")
@onready var heart_scene = preload("res://Content/LevelElement/heart.tscn")
func do_death_animation(position, money_chance, value):
	var is_money = randf_range(0,1) < money_chance
	var reward
	if is_money:
		reward = truffy_scene.instantiate()
		reward.value = 1
	else:
		reward = heart_scene.instantiate()
	
	get_tree().root.add_child(reward)
	reward.global_position = position
