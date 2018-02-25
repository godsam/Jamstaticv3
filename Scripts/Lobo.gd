extends Node2D

signal bite

var isSlap = false
var isBite = false

var life = 100

func _ready():
	set_process(true)

func bite_atach():
	get_node("Anim").play("head")

func on_slap():
	get_node("Anim").play("head")

func _on_AreaArm_body_enter( body ):
	if body.get_name() == "Player":
		get_node("Timer").start()
		yield(get_node("Timer"),"timeout")
		get_node("Anim").play("slap")
		if body.has_method("on_atached"):
			body.on_atached(2)
		isSlap = false


func _on_Area_body_enter( body ):
	if body.get_name() == "Player":
		get_node("Timer").start()
		yield(get_node("Timer"),"timeout")
		get_node("Anim").play("bite")
		if body.has_method("on_atached"):
			body.on_atached(1)
		
		isBite = false


func _on_AreaHit_body_enter( body ):
	if body.get_name() == "Shot":
		life -= 10
		body.queue_free()
	
	if life <= 0:
		get_node("Anim").stop_all()
		get_node("Particles").set_emitting(true)
		get_node("Neck").hide()
