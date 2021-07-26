extends Node

export (PackedScene) var ProtoChar
# Declare member variables here. Examples:
var player_num = 1;
var player_char

# Called when the node enters the scene tree for the first time.
func _ready():
	player_char = ProtoChar.instance()
	player_char.facing = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player_char.handle_inputs(parse_input())

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
