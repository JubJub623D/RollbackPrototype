extends Area2D


# Declare member variables here. Examples:
var startup: int
var active: int
var recovery: int
var hitstun: int
var damage: int
var xPB: int
var yPB: int

var is_active := false
var to_destroy := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	updateState()
	
func updateState() -> void:
	if startup > 0:
		is_active = false
		startup -= 1
	elif active > 0:
		is_active = true
		active -= 1
	elif recovery > 0:
		is_active = false
		recovery -= 1
	else:
		to_destroy = true

func initialize_width_height(width, height):
	var id = shape_find_owner(0)
	var shape = shape_owner_get_shape(0, id)
	shape.set_extents(Vector2(width, height))
