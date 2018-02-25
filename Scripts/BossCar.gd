extends KinematicBody2D

const GRAVITY = 100
const NORMAL = Vector2(0,-1)

var dir = Vector2()

var loboDead = false
var araraDead = false

var life

signal bossDead
signal playerEnd

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	dir.y += GRAVITY * delta
	dir.x = 10
	dir = move_and_slide(dir,NORMAL)
	
	life = get_node("Arara").life + get_node("Lobo").life
	
	if araraDead and loboDead:
		emit_signal("bossDead")

func _on_Arara_defeated():
	araraDead = true

func _on_Lobo_defeated():
	loboDead = true

func _on_Fim_body_enter( body ):
	if body.get_name() == "Player":
		emit_signal("playerEnd")
