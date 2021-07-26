RollbackPrototype is intended to be a barebones, simple-as-possible fighting game that incorporates rollback netcode into online play.
Because rollback is so important in creating a playable online experience in the modern day, 
and because using rollback demands certain design aspects in the inner workings of the game, 
I consider tackling the problem of how to design a fighting game with rollback netcode 
to be the critical first step in designing a good fighting game.

Version 1.0 adds Online functionality, which can be accessed through the Online Vs button.
It uses Godot's native networking functionality, and has yet to implement any rollback functionality.
This is a very early Alpha build, and needs more testing before any advancements can be made.

CONTROLS------------
Player One:
	A/D: Walk Left/Right
	S: Attack
Player Two:
	J/L: Walk Left/Right
	K: Attack 