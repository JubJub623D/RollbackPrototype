extends Node

signal Player_ko
# Declare member variables here. Examples:
#export var player_num = 1;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func parse_input() -> String:
	var parsed_string = "00"
	var player_string = "p" + String(player_num)
	
	if Input.is_action_pressed(player_string + "_left") and !Input.is_action_pressed(player_string + "_right"):
		parsed_string[0] = "L"
	elif Input.is_action_pressed(player_string + "_right") and !Input.is_action_pressed(player_string + "_left"):
		parsed_string[0] = "R"
	else:
		parsed_string[0] = "N"
	
	if Input.is_action_just_pressed(player_string + "_attack"):
		parsed_string[1] = "A"
	elif Input.is_action_just_released(player_string + "_attack"):
		parsed_string[1] = "a"
		
	return parsed_string


func _on_ProtoChar_ko():
	emit_signal("Player_ko")
