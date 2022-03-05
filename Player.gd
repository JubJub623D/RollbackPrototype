extends Node

signal Player_ko
# Declare member variables here. Examples:
export var player_num = 1;


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func update(inputs: int):
	$ProtoChar.update()
	$ProtoChar.handle_inputs(inputs)

func _on_ProtoChar_ko():
	emit_signal("Player_ko")

