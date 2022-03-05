extends Area2D


# Declare member variables here. Examples:
var startup := 8
var active := 5
var recovery := 17
var hitstun := 33
var damage := 334
var xPB := 200
var yPB := 0

var is_active := false
var to_destroy := false

func update_hitbox():
	if startup > 0:
		startup -= 1
		if startup == 0:
			activate()
	elif active > 0:
		active -= 1
		if active == 0:
			deactivate()
	elif recovery > 0:
		recovery -= 1
		if recovery == 0:
			to_destroy = true

func activate():
	is_active = true

func deactivate():
	is_active = false

func Hitbox_SaveState(stream):
	stream.put_16(510)
	stream.put_16(startup)
	stream.put_16(active)
	stream.put_16(recovery)

func Hitbox_LoadState(hitbox_data):
	startup = hitbox_data[1]
	active = hitbox_data[2]
	recovery = hitbox_data[3]
