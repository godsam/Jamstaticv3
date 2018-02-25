extends KinematicBody2D

const GRAVITY = 100
const NORMAL = Vector2(0,-1)

var dir = Vector2()

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	dir.y += GRAVITY * delta
	dir.x = 10
	dir = move_and_slide(dir,NORMAL)
