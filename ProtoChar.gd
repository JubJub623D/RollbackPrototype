extends Node2D

var Attack = preload("res://characters/ProtoChar/hitboxes/AttackHitbox.tscn")

enum {FORWARD_WALK, BACKWARD_WALK, ATTACK, IDLE, HITSTUN, KO}

signal ko

var protochar_state = IDLE
var protochar_facing = 0
var hitstun = 0
const walk_speed = 5
const protochar_max_health = 1000
var protochar_health = 1000

var active_attack = "00"
var hitboxes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_hitboxes()
	destroy_hitboxes()
		

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
		KO:
			$AnimatedSprite.animation = "ko"
	$AnimatedSprite.play()
			
func handle_inputs(input_string):
	var prev_state = protochar_state
	match protochar_state:
		KO:
			pass
		HITSTUN:
			hitstun -= 1
			if hitstun == 0:
				if protochar_health <= 0:
					protochar_state = KO
				else:
					protochar_state = IDLE
		ATTACK:
			if hitboxes.size() == 0:
				protochar_state = IDLE
		_:
			if input_string[1] == "A":
				protochar_state = ATTACK
				active_attack = "5A"
				var new_hitbox = Attack.instance()
				new_hitbox.scale = Vector2(protochar_facing, 1)
				add_child(new_hitbox)
				hitboxes.append(new_hitbox)
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

func check_hitboxes(other_hitboxes):
	for hitbox in other_hitboxes:
		if hitbox.overlaps_area(self) and hitbox.is_active and protochar_state != KO:
			get_hit(hitbox)

func get_hit(hitbox):
	protochar_health -= hitbox.damage
	if protochar_health <= 0:
		emit_signal("ko")
	protochar_state = HITSTUN
	hitstun = hitbox.hitstun
	position.x += hitbox.xPB * -protochar_facing
	position.y += hitbox.yPB * -protochar_facing
	hitbox.deactivate()
	
func update_hitboxes():
	for hitbox in hitboxes:
		hitbox.update_hitbox()

func destroy_hitboxes():
	var new_hitboxes = []
	for hitbox in hitboxes:
		if !hitbox.to_destroy:
			new_hitboxes.append(hitbox)
	for hitbox in hitboxes:
		if not hitbox in new_hitboxes:
			hitbox.queue_free()
	hitboxes = new_hitboxes
	
func reset_health():
	protochar_health = protochar_max_health
	protochar_state = IDLE
	
