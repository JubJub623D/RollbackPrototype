extends Node2D

enum {FORWARD_WALK, BACKWARD_WALK, ATTACK, IDLE, HITSTUN}

signal ko

var protochar_state = IDLE
var protochar_facing = 0
const walk_speed = 5
const protochar_initial_health = 1000

var is_active := false
var active_attack = "00"
var startup_timer := 0
var active_timer := 0
var recovery_timer := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_hitboxes()

func control_animation(prev_state):
	match protochar_state:
		FORWARD_WALK:
			$AnimatedSprite.animation = "walk_forward"
		BACKWARD_WALK:
			$AnimatedSprite.animation = "walk_backward"
		ATTACK:
			$AnimatedSprite.animation = "attack"
		IDLE:
			$AnimatedSprite.animation = "idle"
		HITSTUN:
			$AnimatedSprite.animation = "hitstun"
	$AnimatedSprite.play()
			
func handle_inputs(input_string):
	var prev_state = protochar_state
	match protochar_state:
		HITSTUN:
			pass
		ATTACK:
			pass
		_:
			if input_string[1] == "A":
				protochar_state = ATTACK
				active_attack = "5A"
				startup_timer = 8
				active_timer = 5
				recovery_timer = 17
			elif input_string[0] == "L":
				walk(-1)
			elif input_string[0] == "R":
				walk(1)
			else:
				protochar_state = IDLE
	control_animation(prev_state)
	
func walk(direction):
	if protochar_facing * direction == 1:
		protochar_state = FORWARD_WALK
	elif protochar_facing * direction == -1:
		protochar_state = BACKWARD_WALK
	position.x += direction * walk_speed

func facing(direction):
	protochar_facing = direction
	if direction == 1:
		$AnimatedSprite.flip_h = false
	elif direction == -1:
		$AnimatedSprite.flip_h = true

func update_hitboxes():
	if startup_timer > 0:
		startup_timer -= 1
		#print(startup_timer)
		if startup_timer == 0:
			is_active = true
	elif active_timer > 0:
		active_timer -= 1
		#print(is_active)
		if active_timer == 0:
			is_active = false
	elif recovery_timer > 0:
		recovery_timer -= 1
		if recovery_timer == 0:
			protochar_state = IDLE

func _on_attack_hit(body):
	if is_active:
		print(body.name)
		print("hi!")
