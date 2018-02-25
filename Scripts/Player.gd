extends KinematicBody2D

const GRAVITY = 300
const WALK_SPEED = 100
const FORCE = 250
const SPEED_SHOT = 50
const SPEED_DIR = 500
const NORMAL = Vector2(0,-1)

var vel = Vector2()
var dir = Vector2()

var mouse = 0
var vari = 0 # variância do tiro
var life = 200
var enemyLife = 0

var bJump = true
var waited = true

var anim_run = false
var anim_idle = false
var anim_fall = false

var preshot = preload("res://Scenes/Shot.tscn")

signal isdead

func on_atached(tipo = 0):
	if get_node("Sprite").is_flipped_h():
		get_node(".").move_and_slide(Vector2(1000,0),NORMAL)
	else:
		get_node(".").move_and_slide(Vector2(-1000,0),NORMAL)
	if tipo == 0:
		print("dano = 1")
	elif tipo == 1:
		life -= 50
	elif tipo == 2:
		life -= 10
	elif tipo == 3:
		print("dano fatal")
	
	if life <= 0:
		emit_signal("isdead")

func _ready():
	set_fixed_process(true)
	randomize()

func _fixed_process(delta):
	vel.y += GRAVITY * delta
	vari = rand_range(-10,10)
	
	get_node("Label1").set_text("Life: " + str(life))
	get_node("Label2").set_text("Enemy: " + str(enemyLife))
	
	if is_move_and_slide_on_floor():
		bJump = false
	
	if Input.is_action_pressed("move_right"):
		vel.x = WALK_SPEED
		dir = Vector2(SPEED_DIR,0)
		get_node("Sprite").set_flip_h(false)
		if !bJump:
			if !anim_run:
				get_node("Anim").play("Run")
				anim_run = true
				anim_fall = false
				anim_idle = false
		elif vel.y >= 0:
			if !anim_fall:
				get_node("Anim").play("fall")
				anim_fall = true
				anim_idle = false
				anim_run = false
	elif Input.is_action_pressed("move_left"): 
		vel.x = -WALK_SPEED
		dir = Vector2(-SPEED_DIR,0)
		get_node("Sprite").set_flip_h(true)
		if !bJump:
			if !anim_run:
				get_node("Anim").play("Run")
				anim_run = true
				anim_fall = false
				anim_idle = false
		elif vel.y >= 0:
			if !anim_fall:
				get_node("Anim").play("fall")
				anim_fall = true
				anim_idle = false
				anim_run = false
	else:
		vel.x = 0
		if !bJump:
			if !anim_idle:
				get_node("Anim").play("Idle")
				anim_idle = true
				anim_fall = false
				anim_run = false
		elif vel.y >= 0:
			if !anim_fall:
				get_node("Anim").play("fall")
				anim_fall = true
				anim_idle = false
				anim_run = false
	
	if Input.is_action_pressed("move_up"):
		dir.y = -SPEED_DIR
		
		if vel.x == 0:
			dir.x = 0
	elif Input.is_action_pressed("move_down"):
		dir.y = SPEED_DIR
		
		if vel.x == 0:
			dir.x = 0
	else:
		dir.y = 0
		
		if get_node("Sprite").is_flipped_h():
			dir.x = -SPEED_DIR
		else:
			dir.x = SPEED_DIR
	
	if Input.is_action_pressed("move_jump") and !bJump:
		vel.y = -FORCE
		bJump = true
		get_node("Anim").play("Jump")
	
	vel = move_and_slide(vel,NORMAL)
	
	if Input.is_action_pressed("shot") and waited:
		var shot = preshot.instance()
		get_parent().add_child(shot)
		shot.set_global_pos(get_global_pos())
		shot.apply_impulse(Vector2(),(dir * SPEED_SHOT * delta))
		shot.set_angular_velocity(vari)
		waited = false
		get_node("Timer").start()

func _on_Timer_timeout():
	waited = true
