extends Control

var Stage = preload("res://Stage.tscn")

const DEFAULT_IP = '127.0.0.1'
const DEFAULT_PORT = '5000'

onready var address = $MarginContainer/VBoxContainer/GridContainer/IPAddr
onready var port = $MarginContainer/VBoxContainer/GridContainer/Port
onready var host_button = $MarginContainer/VBoxContainer/Host
onready var join_button = $MarginContainer/VBoxContainer/Join
onready var status = $MarginContainer/VBoxContainer/Status

var peer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect all the callbacks related to networking.
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	hide_status()
	address.text = DEFAULT_IP
	port.text = DEFAULT_PORT

#### Network callbacks from SceneTree ####

# Callback from SceneTree.
func _player_connected(_id):
	# Someone connected, start the game!
	var stage = Stage.instance()
	get_tree().get_root().add_child(stage)
	hide()


func _player_disconnected(_id):
	if get_tree().is_network_server():
		end_game("Client disconnected")
	else:
		end_game("Server disconnected")


# Callback from SceneTree, only for clients (not server).
func _connected_ok():
	pass


# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	set_status("Couldn't connect")

	get_tree().set_network_peer(null) # Remove peer.
	host_button.set_disabled(false)
	join_button.set_disabled(false)


func _server_disconnected():
	end_game("Server disconnected")

#GUI Methods
func set_status(txt):
	status.text = txt
	status.show()

func hide_status():
	status.text = ""
	status.hide()	

#Management Methods
func end_game(with_error = ""):
	if has_node("/root/Stage"):
		# Erase immediately, otherwise network might show
		# errors (this is why we connected deferred above).
		get_node("/root/Stage").free()

	get_tree().set_network_peer(null) # Remove peer.
	host_button.set_disabled(false)
	join_button.set_disabled(false)

	show()
	set_status(with_error)

#Button Methods
func _on_Host_pressed():
	peer = NetworkedMultiplayerENet.new()
	peer.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = peer.create_server(int(DEFAULT_IP), 1) 
	if err != OK:
		set_status(err)
		return
		
	get_tree().set_network_peer(peer)
	host_button.set_disabled(true)
	join_button.set_disabled(true)
	set_status("Waiting for opponent to connect...")

func _on_Join_pressed():
	var ip = address.get_text()
	if not ip.is_valid_ip_address():
		set_status("IP address is invalid")
		return
	var port_num = port.get_text()

	peer = NetworkedMultiplayerENet.new()
	peer.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = peer.create_client(ip, int(port_num))
	if err != OK:
		set_status(err)
		return
	get_tree().set_network_peer(peer)


func _on_Back_pressed():
	queue_free()
