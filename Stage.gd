extends Node


# Declare member variables here. Examples:
const rounds_to_win := 3
var p1rounds := 0
var p2rounds := 0

signal game_over

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player1.player_num = 1
	$Player2.player_num = 2
	
	$StageHUD.display_ready()
	yield(get_tree().create_timer(1.0), "timeout")
	$StageHUD.hide_msg()
	start_round()

	
func Update(inputs):
	$Player1.update(inputs[0])
	$Player2.update(inputs[1])
	stage_process()

func Stage_SaveState(stream):
	stream.put_16(p1rounds)
	stream.put_16(p2rounds)
	$Player1/ProtoChar.ProtoChar_SaveState(stream)
	$Player2/ProtoChar.ProtoChar_SaveState(stream)

func Stage_LoadState(stream):
	p1rounds = stream.get_16()
	p2rounds = stream.get_16()
	$Player1/ProtoChar.ProtoChar_LoadState(stream)
	$Player2/ProtoChar.ProtoChar_LoadState(stream)

func stage_process():
	stage_collision()
	
	if $Player1/ProtoChar.position.x < $Player2/ProtoChar.position.x:
		$Player1/ProtoChar.facing(1)
		$Player2/ProtoChar.facing(-1)
	else:
		$Player1/ProtoChar.facing(-1)
		$Player2/ProtoChar.facing(1)
	
	$Player1/ProtoChar.check_hitboxes($Player2/ProtoChar.hitboxes)
	$Player2/ProtoChar.check_hitboxes($Player1/ProtoChar.hitboxes)
	
	$StageHUD.set_health($Player1/ProtoChar.protochar_health, $Player2/ProtoChar.protochar_health)

func _on_Player1_Player_ko():
	p2rounds += 1
	$StageHUD.set_rounds(p1rounds, p2rounds)
	
	$StageHUD.display_win(2)
	if p2rounds >= 3:
		yield(get_tree().create_timer(3.0), "timeout")
		emit_signal("game_over")
	else:		
		yield(get_tree().create_timer(1.0), "timeout")
		$StageHUD.hide_msg()
		start_round()


func _on_Player2_Player_ko():
	p1rounds += 1
	$StageHUD.set_rounds(p1rounds, p2rounds)
	
	$StageHUD.display_win(1)
	if p1rounds >= 3:
		yield(get_tree().create_timer(3.0), "timeout")
		emit_signal("game_over")
	else:
		yield(get_tree().create_timer(1.0), "timeout")
		$StageHUD.hide_msg()
		start_round()
	
func start_round():
	$Player1/ProtoChar.position = Vector2(300, 550)
	$Player1/ProtoChar.facing(1)
	$Player2/ProtoChar.position = Vector2(750, 550)
	$Player2/ProtoChar.facing(-1)
	$Player1/ProtoChar.reset_health()
	$Player2/ProtoChar.reset_health()

func stage_collision():
	if $Player1/ProtoChar.overlaps_area($StageArea):
		var extents = $Player1/ProtoChar/CollisionShape2D.shape.extents
		var width = extents.x 
		var p1_x = $Player1/ProtoChar.position.x
		if p1_x < 200:
			$Player1/ProtoChar.position.x = 0 + width
		if p1_x > 825:
			$Player1/ProtoChar.position.x = 1025 - width
	if $Player2/ProtoChar.overlaps_area($StageArea):
		var extents = $Player2/ProtoChar/CollisionShape2D.shape.extents
		var width = extents.x
		var p2_x = $Player2/ProtoChar.position.x
		if p2_x < 200:
			$Player2/ProtoChar.position.x = 0 + width
		if p2_x > 825:
			$Player2/ProtoChar.position.x = 1025 - width
