extends Node2D

signal bite
signal defeated

var life = 100

var atached = false

func _ready():
	set_process(true)

func bite_atach():
	get_node("Anim").play("head")

func on_slap():
	get_node("Anim").play("head")

func _on_AreaArm_body_enter( body ):
	if !atached:
		if body.get_name() == "Player":
			get_node("Anim").play("slap")
			atached = true
			
			if body.has_method("on_atached"):
				body.on_atached(2)
			
			get_node("Timer").start()

func _on_Area_body_enter( body ):
	if !atached:
		if body.get_name() == "Player":
			atached = true
			get_node("Anim").play("bite")
			if body.has_method("on_atached"):
				body.on_atached(1)
			
			get_node("Timer").start()

func _on_AreaHit_body_enter( body ):
	if body.get_name() == "Shot":
		life -= 10
		body.queue_free()
	
	if life <= 0:
		get_node("Anim").stop_all()
		get_node("Neck").hide()
		emit_signal("defeated")

func _on_Timer_timeout():
	atached = false
