RollbackPrototype is intended to be a barebones, simple-as-possible fighting game that incorporates rollback netcode into online play.
Because rollback is so important in creating a playable online experience in the modern day, 
and because using rollback demands certain design aspects in the inner workings of the game, 
I consider tackling the problem of how to design a fighting game with rollback netcode 
to be the critical first step in designing a good fighting game.

Version 1.0 makes the critical leap:
Now OnlineVs uses GGPO and FlutterTal's GGPO-Godot Module to provide Online Vs functionality,
complete with rollback netcode.
So far, this build has only been tested through a loopback connection, 
without any artificially induced latency (ie: clumsy), so it remains a test-build.

TO-DO:
 - Replace the floating-point positional math with fixed-point math, allowing for perfect determinism
 - Ensure that the netcode functions as intended when latency is introduced

CONTROLS------------
Player One:
	A/D: Walk Left/Right
	S: Attack
Player Two:
	J/L: Walk Left/Right
	K: Attack 