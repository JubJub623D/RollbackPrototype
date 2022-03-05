extends CanvasLayer

var LocalVs = preload("res://LocalVs.tscn")
#var Stage = preload("res://Stage.tscn")
var OnlineVsGUI = preload("res://OnlineVsGUI.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_LocalVs_pressed():
	var localvs = LocalVs.instance()
	add_child(localvs)


func _on_OnlineVs_pressed():
	var gui = OnlineVsGUI.instance()
	add_child(gui)
	
	
func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		get_tree().quit()
