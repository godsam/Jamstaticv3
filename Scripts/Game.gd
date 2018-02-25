extends Node

var prefloor = preload("res://Scenes/Floor.tscn")
var prewall1 = preload("res://Scenes/Wall1.tscn")
var prewall2 = preload("res://Scenes/Wall2.tscn")
var preboss = preload("res://Scenes/BossCar.tscn")
var preplayer = preload("res://Scenes/Player.tscn")
var preend = preload("res://Scenes/EndOfGame.tscn")

var i = 0
var poswall = Vector2(0,74)
var posfloor = Vector2(0,178)
var posplayer = Vector2(700,0)
var posboss = Vector2(200,-100)

var inGame = false

var player
var boss
var endgame

signal screen

func _ready():
	set_process(true)
	
	while i < 16:
		i += 1
		var wall
		var floor1 = prefloor.instance()
		if i % 4 == 0:
			wall = prewall1.instance()
		else:
			wall = prewall2.instance()
		
		get_node("Wall").add_child(wall)
		wall.set_global_pos(poswall)
		poswall += Vector2(72,0)
		
		if i < 12:
			get_node("Floor").add_child(floor1)
			floor1.set_global_pos(posfloor)
			if i < 10:
				get_node("Fim").set_global_pos(posfloor)
			
			posfloor += Vector2(112,0)
	
	new_game()

func _on_Fim_body_enter( body ):
	if body.get_name() == "Player":
		EndOfGame("LOSE")

func EndOfGame(extra = ""):
	inGame = false
	endgame = preend.instance()
	
	if extra != "":
		endgame.vitory = extra
	
	add_child(endgame)
	endgame.get_node("Camera").set_global_pos(player.get_node("Camera").get_global_pos() - Vector2(0,20))
	endgame.connect("restart",self,"new_game")
	endgame.connect("title",self,"on_close")
	
	player.queue_free()
	boss.queue_free()

func on_close():
	emit_signal("screen")
	queue_free()

func new_game():
	if endgame != null:
		endgame.queue_free()
	
	boss = preboss.instance()
	add_child(boss)
	boss.set_global_pos(posboss)
	boss.connect("bossDead",self,"on_boss_dead")
	boss.connect("playerEnd",self,"on_player_end")
	
	player = preplayer.instance()
	add_child(player)
	player.set_global_pos(posplayer)
	player.connect("isdead",self,"on_player_dead")
	
	inGame = true

func on_player_end():
	if inGame:
		EndOfGame("LOSE")

func on_player_dead():
	if inGame:
		EndOfGame("LOSE")

func on_boss_dead():
	EndOfGame("WIN")

func _process(delta):
	if inGame:
		player.enemyLife = boss.life
