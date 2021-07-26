extends Node2D

#Essentially, this imports the Hitbox scene in order to create instances of it
var Hitbox = preload("res://Hitbox.tscn")

enum {FORWARD_WALK, BACKWARD_WALK, ATTACK, IDLE, HITSTUN}

signal ko

var protochar_state = IDLE
var protochar_facing = 0
const walk_speed = 5
const protochar_initial_health = 1000

var recovery_timer = 0

var hitboxes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if protochar_state == ATTACK and recovery_timer > 0:
		recovery_timer -= 1
	elif protochar_state == ATTACK and recovery_timer == 0:
		protochar_state = IDLE

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
				create_hitbox(750, 550, 50, 10, 8, 5, 17, 32, 334, 20, 0)
				recovery_timer = 30
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

func create_hitbox(xOffset, yOffset, width, height, 
	startup, active, recovery,
	hitstun, damage,
	xPB, yPB):
	var new_hitbox = Hitbox.instance()
	
	new_hitbox.position.x = xOffset
	new_hitbox.position.y = yOffset
	new_hitbox.initialize_width_height(width, height)
	new_hitbox.startup = startup
	new_hitbox.active = active
	new_hitbox.recovery = recovery
	new_hitbox.hitstun = hitstun
	new_hitbox.damage = damage
	new_hitbox.xPB = xPB
	new_hitbox.yPB = yPB
	
	hitboxes.append(new_hitbox)

func destroy_hitboxes():
	var new_hitboxes = []
	for hitbox in hitboxes:
		if !hitbox.to_destroy:
			new_hitboxes.append(hitbox)
	hitboxes = new_hitboxes

func process_hitboxes(other_hitboxes):
	for hitbox in other_hitboxes:
		if hitbox.overlaps_area($ProtoChar):
			print("hi!")

func _on_hit(body):
	print(body.name + "hi")
