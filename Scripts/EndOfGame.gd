extends Node

signal restart
signal title

var vitory = ""

var novoGame = false

func _ready():
	set_process(true)
	get_node("Camera/Label").set_text(vitory)

func _process(delta):
	if Input.is_action_pressed("move_right"):
		novoGame = false
	elif Input.is_action_pressed("move_left"):
		novoGame = true
	
	if novoGame:
		get_node("Camera/Label3").set_text(str(int(get_node("Timer").get_time_left())))
		get_node("Camera/Label5").show()
		get_node("Camera/Label4").hide()
	else:
		get_node("Camera/Label3").set_text(str(int(get_node("Timer").get_time_left())))
		get_node("Camera/Label5").hide()
		get_node("Camera/Label4").show()

func _on_Timer_timeout():
	if novoGame:
		emit_signal("restart")
		queue_free()
	else:
		emit_signal("title")
		queue_free()
