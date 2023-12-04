extends Node2D
signal ready_resetable
@onready var room = get_parent()
@onready var area = room.get_parent()

func create_scene():
	var packed_scene = PackedScene.new()
	recursive_set_owner(self, self)
	packed_scene.pack(self)
	return packed_scene

func recursive_set_signal(node):
	if node != self:
		if node.has_method("ready_resetable"):
			connect("ready_resetable", node.ready_resetable)
	#for child in node.get_children():
		#recursive_set_owner(child)

func recursive_set_owner(scene_root, node):
	if node != self:
		if node.owner != scene_root:
			node.owner = self
		if node.scene_file_path:
			scene_root = node
	for child in node.get_children():
		recursive_set_owner(scene_root, child)

func init_children():
	pass
