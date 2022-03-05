extends Control

var OnlineVs = preload("res://OnlineVs.tscn")

const DEFAULT_IP = '127.0.0.1'
const DEFAULT_PORT = '5000'
const DEFAULT_DELAY = '0'

onready var address = $MarginContainer/VBoxContainer/GridContainer/IPAddr
onready var port = $MarginContainer/VBoxContainer/GridContainer/Port
onready var delayframes = $MarginContainer/VBoxContainer/GridContainer/DelayFrames
onready var host_button = $MarginContainer/VBoxContainer/Host
onready var join_button = $MarginContainer/VBoxContainer/Join
onready var getip_button = $MarginContainer/VBoxContainer/GetIP
onready var status = $MarginContainer/VBoxContainer/Status

var peer = null

var client_address: String
var client_port: int


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("connection_failed", self, "_connected_fail")
	
	hide_status()
	address.text = DEFAULT_IP
	port.text = DEFAULT_PORT
	delayframes.text = DEFAULT_DELAY
	
	
#### Network callbacks from SceneTree ####

# Callback from SceneTree.
func _player_connected(_id):
	if is_network_master():
		client_address = String(peer.get_peer_address(_id))
		client_port = int(peer.get_peer_port(_id))
		rpc("set_client", client_address, client_port)
	yield(get_tree().create_timer(2.0), "timeout")
	
	address.editable = true
	port.editable = true
	delayframes.editable = true
	host_button.set_disabled(false)
	join_button.set_disabled(false)
	getip_button.set_disabled(false)
	hide_status()
	
	peer.close_connection()
	get_tree().set_network_peer(null)
	var onlinevs = OnlineVs.instance()
	onlinevs.init_onlinevs(int(delayframes.text), address.text, int(port.text), client_address, client_port, _id)
	add_child(onlinevs)

remotesync func set_client(address, port):
	client_address = address
	client_port = port

# Callback from SceneTree, only for clients (not server).
func _connected_fail():
	set_status("Couldn't connect")

	get_tree().set_network_peer(null) # Remove peer.
	address.editable = true
	port.editable = true
	delayframes.editable = true
	host_button.set_disabled(false)
	join_button.set_disabled(false)
	getip_button.set_disabled(false)



#GUI Methods
func set_status(txt):
	status.text = txt
	status.show()

func hide_status():
	status.text = ""
	status.hide()	


#Button Methods
func _on_Host_pressed():
	peer = NetworkedMultiplayerENet.new()
	peer.set_bind_ip(address.text)
	peer.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = peer.create_server(int(port.text), 1) 
	if err != OK:
		set_status(String(err))
		return
		
	get_tree().set_network_peer(peer)
	address.editable = false
	port.editable = false
	delayframes.editable = false
	host_button.set_disabled(true)
	join_button.set_disabled(true)
	getip_button.set_disabled(true)
	set_status("Waiting for opponent to connect...")

func _on_Join_pressed():
	var ip = address.get_text()
	if not ip.is_valid_ip_address():
		set_status("IP address is invalid")
		return

	peer = NetworkedMultiplayerENet.new()
	peer.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = peer.create_client(ip, int(port.get_text()))
	if err != OK:
		set_status(String(err))
		return
		
	get_tree().set_network_peer(peer)
	address.editable = false
	port.editable = false
	delayframes.editable = false
	host_button.set_disabled(true)
	join_button.set_disabled(true)
	getip_button.set_disabled(true)
	set_status("Attempting to connect...")


func _on_Back_pressed():
	queue_free()

#IP Retrieval methods
func _on_GetIP_pressed():
	$IPify.request("https://api.ipify.org")
	set_status("Fetching your IPv4 from IPify...")

func _on_IPify_request_completed(_result, _response_code, _headers, body):
	var your_ip = body.get_string_from_utf8()
	address.text = your_ip
	set_status("IPv4 successfully retrieved!")
