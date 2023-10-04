extends Node2D

@export var rad_speed = 2 * PI / 5

@onready var radius = $ToSpin.position.length()
@onready var spin_rotation = $ToSpin.position.angle()

func _ready():
	pass

func _physics_process(delta):
	spin_rotation += rad_speed * delta
	$ToSpin.position = radius * Vector2(cos(spin_rotation), sin(spin_rotation))
