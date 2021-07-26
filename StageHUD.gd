extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_msg()

func display_win(player_num):
	$Message.text = "Player " + String(player_num) + " wins!"
	$Message.show()

func display_ready():
	$Message.text = "Get Ready!"
	$Message.show()

func hide_msg():
	$Message.text = ""
	$Message.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	
func hide_ready():
	pass

func set_health(p1health, p2health):
	$Player1Lifebar.value = p1health
	$Player2Lifebar.value = p2health
	
func set_rounds(p1rounds, p2rounds):
	$Player1Rounds.animation = String(p1rounds) + "_round"
	$Player2Rounds.animation = String(p2rounds) + "_round"
