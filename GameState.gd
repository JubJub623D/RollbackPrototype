extends Node


var stageNode

func _init(stage):
	stageNode = stage

func Update(inputs):
	stageNode.Update(inputs)


func Save_GameState():
	var stream = StreamPeerBuffer.new()
	stream.clear()
	stream.put_32(0) #Reserves space for 32-bit checksum
	stageNode.Stage_SaveState(stream)
	
	var check = CalcFletcher32(stream)
	stream.seek(0)
	stream.put_32(check)
	
	return stream
	
func Load_GameState(stream):
	stream.seek(0) # Sets the position indicator for the StreamPeerBuffer to 0.
	stream.get_32() # Removes the checksum 
	stageNode.Stage_LoadState(stream)


#Ripped this code from the GameState.gd script in 
#https://github.com/pecefulpro/GGPO-tutorial-
#Calculates a 32-bit checksum given some data.
func CalcFletcher32(data):
	var sum1 = 0
	var sum2 = 0
	var index = data.get_data_array()
	for i in range(index.size()):
		sum1 = (sum1 + index[i]) % 0xffff
		sum2 = (sum2 + sum1) % 0xffff
	
	return (int(sum2 << 16) | sum1)
	
