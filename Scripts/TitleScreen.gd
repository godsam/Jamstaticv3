extends Node

var pregame = preload("res://Scenes/Game.tscn")

var onGame = false

func _ready():
	set_process(true)

func _process(delta):
	if !onGame:
		if Input.is_action_pressed("move_jump"):
			novo_game()
			onGame = true

func novo_game():
	var game = pregame.instance()
	add_child(game)
	game.connect("screen",self,"on_screen")

func on_screen():
	onGame = false