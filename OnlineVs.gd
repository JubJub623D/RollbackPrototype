extends Node

var GameState = preload("res://GameState.gd")
var Stage = preload("res://Stage.tscn")
var state

var is_host := true
var session_result
var local_address
var local_port
var remote_address
var remote_port
var delayframes

var local_player
var remote_player

var game_over := false

const HOST_HANDLE = 1
const CLIENT_HANDLE = 2


func _ready():
	session_result = GGPO.startSession("rollbackprototype_test", 2, local_port)
	if is_host:
		local_player = GGPO.addPlayer(GGPO.PLAYERTYPE_LOCAL, HOST_HANDLE, local_address, local_port)
	else:
		local_player = GGPO.addPlayer(GGPO.PLAYERTYPE_LOCAL, CLIENT_HANDLE, local_address, local_port)
	print(local_player)
	GGPO.setFrameDelay(local_player["playerHandle"], delayframes)
	
	if is_host:
		remote_player = GGPO.addPlayer(GGPO.PLAYERTYPE_REMOTE, CLIENT_HANDLE, remote_address, remote_port)
	else:
		remote_player = GGPO.addPlayer(GGPO.PLAYERTYPE_REMOTE, HOST_HANDLE, remote_address, remote_port)
	
	print(remote_player)
	
	state = GameState.new(Stage.instance())
	add_child(state)
	add_child(state.stageNode)
	GGPO.createInstance(state, "Save_GameState")
	state.stageNode.connect("game_over", self, "_onGameOver")
	
func init_onlinevs(delay, server_address, server_port, client_address, client_port, remote_id):
	connect_signals()
	delayframes = delay
	
	if remote_id == 1:
		is_host = false
	address_port_init(server_address, server_port, client_address, client_port, remote_id)
	
func address_port_init(server_address, server_port, client_address, client_port, remote_id):
	if is_host:
		local_address = server_address
		local_port = server_port
		remote_address = client_address
		remote_port = client_port
	else:
		remote_address = server_address
		remote_port = server_port
		local_address = client_address
		local_port = client_port

func connect_signals():
	GGPO.connect("advance_frame", self, "_onAdvanceFrame")
	GGPO.connect("load_game_state", self, "_onLoadGameState")
	GGPO.connect("event_disconnected_from_peer", self, "_onEventDisconnectedFromPeer")
	GGPO.connect("save_game_state", self, "_onSaveGameState")
	GGPO.connect("event_connected_to_peer", self, "_onEventConnectedToPeer")
	
	GGPO.connect("event_synchronizing_with_peer", self, "_onEventSynchronizingWithPeer")
	GGPO.connect("event_synchronized_with_peer", self, "_onEventSynchronizedWithPeer")
	GGPO.connect("event_running", self, "_onEventRunning")
	GGPO.connect("log_game_state", self, "_onLogGameState")
	GGPO.connect("event_timesync", self, "_onEventTimesync")
	GGPO.connect("event_connection_interrupted", self, "_onEventConnectionInterrupted")
	GGPO.connect("event_connection_resumed", self, "_onEventConnectionResumed")

func _physics_process(delta):
	if !game_over:
		GGPO.idle(1000/60 - 1)
		var local_input = onlinevs_inputs()
		var result 
		
		if local_player["playerHandle"] != GGPO.INVALID_HANDLE:
			result = GGPO.addLocalInput(local_player["playerHandle"], local_input)
		if result == GGPO.ERRORCODE_SUCCESS:
			result = GGPO.synchronizeInput(2)
			if result["result"] == GGPO.ERRORCODE_SUCCESS:
				state.Update(result["inputs"])
				GGPO.advanceFrame()
	

func onlinevs_inputs():
	var input = 0
	
	if is_host:
		if Input.is_action_pressed("p1_left") and !Input.is_action_pressed("p1_right"):	
			input += 400
		elif Input.is_action_pressed("p1_right") and !Input.is_action_pressed("p1_left"):
			input += 600	
		if Input.is_action_just_pressed("p1_attack"):
			input += 1
	else:
		if Input.is_action_pressed("p2_left") and !Input.is_action_pressed("p2_right"):
			input += 400
		elif Input.is_action_pressed("p2_right") and !Input.is_action_pressed("p2_left"):
			input += 600
		if Input.is_action_just_pressed("p2_attack"):
			input += 1
	
	return input

func close_game():
	game_over = true
	GGPO.closeSession()
	queue_free()

#Callbacks

func _onGameOver():
	close_game()

func _onAdvanceFrame(inputs):
	state.Update(inputs)
	GGPO.advanceFrame()

func _onLoadGameState(buffer):
	state.Load_GameState(buffer)

func _onSaveGameState():
	pass
	
func _onLogGameState(_filename, _buffer):
	#print("state logged")
	pass

func _onEventConnectedToPeer(_player):
	#print("connected!")
	pass
	
func _onEventDisconnectedFromPeer(_player):
	close_game()

func _onEventSynchronizingWithPeer(_player, _count, _total):
	#print("synchronizing...")
	pass
	
func _onEventSynchronizedWithPeer(_player):
	#print("synchronized!")
	pass
	
func _onEventRunning():
	#print("running!")
	pass

func _onEventTimesync(framesahead):
	#print("timesync" + String(framesahead))
	pass

func _onEventConnectionInterrupted(_player, _disconnecttimeout):
	#print("connection interrupted")
	pass
	
func _onEventConnectionResumed(_player):
	#print("connection interrupted")
	pass

