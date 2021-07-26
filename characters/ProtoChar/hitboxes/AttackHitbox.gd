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

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
