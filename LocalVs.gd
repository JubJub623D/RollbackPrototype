extends Node

var Stage = preload("res://Stage.tscn")
var stage

# Called when the node enters the scene tree for the first time.
func _ready():
	stage = Stage.instance()
	add_child(stage)
	stage.connect("game_over", self, "_onGameOver")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	stage.Update(localvs_inputs())

func localvs_inputs():
	var inputs = []
	
	var p1_input = 0
	var p2_input = 0
	
	if Input.is_action_pressed("p1_left") and !Input.is_action_pressed("p1_right"):
		p1_input += 400
	elif Input.is_action_pressed("p1_right") and !Input.is_action_pressed("p1_left"):
		p1_input += 600	
	if Input.is_action_just_pressed("p1_attack"):
		p1_input += 1

	if Input.is_action_pressed("p2_left") and !Input.is_action_pressed("p2_right"):
		p2_input += 400
	elif Input.is_action_pressed("p2_right") and !Input.is_action_pressed("p2_left"):
		p2_input += 600	
	if Input.is_action_just_pressed("p2_attack"):
		p2_input += 1
	
	inputs.append(p1_input)
	inputs.append(p2_input)
	return inputs

func _onGameOver():
	queue_free()
