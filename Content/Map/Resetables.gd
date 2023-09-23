extends Node2D
signal ready_resetable
@onready var room = get_parent()
@onready var area = room.get_parent()

func create_scene():
	var packed_scene = PackedScene.new()
	recursive_set_owner(self)
	packed_scene.pack(self)
	return packed_scene

func recursive_set_signal(node):
	if node != self:
		if node.has_method("ready_resetable"):
			connect("ready_resetable", node.ready_resetable)
	for child in node.get_children():
		recursive_set_owner(child)

func recursive_set_owner(node):
	#This line turns all scenes into local branches to prevent a duplication bug
	#node.set_filename("")
	if node != self:
		node.set_owner(self)
	for child in node.get_children():
		recursive_set_owner(child)
	return

func init_children():
	pass
