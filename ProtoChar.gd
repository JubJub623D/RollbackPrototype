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

var active_attack = 0
var hitboxes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
		
func update():
	update_hitboxes()
	destroy_hitboxes()

func ProtoChar_SaveState(stream):
	stream.put_16(position.x)
	stream.put_16(protochar_state)
	stream.put_16(protochar_facing)
	stream.put_16(hitstun)
	stream.put_16(protochar_health)
	stream.put_16(active_attack)
	if hitboxes.size() == 0:
		stream.put_64(0)
	else:
		hitboxes[0].Hitbox_SaveState(stream)

func ProtoChar_LoadState(stream):
	position.x = stream.get_16()
	protochar_state = stream.get_16()
	protochar_facing = stream.get_16()
	hitstun = stream.get_16()
	protochar_health = stream.get_16()
	active_attack = stream.get_16() 
	var hitbox_data = [stream.get_16(), stream.get_16(), stream.get_16(), stream.get_16()]
	if hitbox_data[0] == 0:
		if hitboxes.size() != 0:
			#this is a scuffed way to destroy the hitbox but w/e
			hitboxes[0].to_destroy = true
	else:
		if hitboxes.size() != 0:
			hitboxes[0].Hitbox_LoadState(hitbox_data)
		else:
			protochar_state = ATTACK
			active_attack = 510 #5A, with the A in hex
			var new_hitbox = Attack.instance()
			new_hitbox.scale = Vector2(protochar_facing, 1)
			new_hitbox.Hitbox_LoadState(hitbox_data)
			add_child(new_hitbox)
			hitboxes.append(new_hitbox)


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
			
func handle_inputs(input_int):
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
				active_attack = 0
				protochar_state = IDLE
		_:
			if input_int % 100 == 1:
				protochar_state = ATTACK
				active_attack = 510 #5A, with the A in hex
				var new_hitbox = Attack.instance()
				new_hitbox.scale = Vector2(protochar_facing, 1)
				add_child(new_hitbox)
				hitboxes.append(new_hitbox)
			elif input_int / 100 == 4:
				walk(-1)
			elif input_int / 100 == 6:
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
	
