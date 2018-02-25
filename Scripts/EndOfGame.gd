extends Node

signal restart
signal title

var novoGame = false

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("move_right"):
		novoGame = false
	elif event.is_action_pressed("move_left"):
		novoGame = true

func _on_Timer_timeout():
	if novoGame:
		emit_signal("restart")
	else:
		emit_signal("title")
		queue_free()
