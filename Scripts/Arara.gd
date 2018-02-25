extends Node2D

var life = 100

signal defeated

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _on_Area_body_enter( body ):
	if body.get_name() == "Shot":
		life -= 10
		body.queue_free()
	
	if life <= 0:
		get_node("Neck").hide()
		get_node("Anim").stop_all()
		emit_signal("defeated")
