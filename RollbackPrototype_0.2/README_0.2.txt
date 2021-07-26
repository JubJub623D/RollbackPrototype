RollbackPrototype is intended to be a barebones, simple-as-possible fighting game that incorporates rollback netcode into online play.
Because rollback is so important in creating a playable online experience in the modern day, 
and because using rollback demands certain design aspects in the inner workings of the game, 
I consider tackling the problem of how to design a fighting game with rollback netcode 
to be the critical first step in designing a good fighting game.

Version 0.2 improves on Version 0.0 by adding a main menu, which allows you to 
select a Local Versus match, and displays controls for Player One and Player Two.
Despite having a button to select an Online Versus match,
this button does nothing since Online functionality has not yet been implemented.
In addition, a background visual has been added. 
(This serves the dual purpose of making the fight look nicer, and to
prevent the player from being alerted to the fact that the fight is being drawn
over the main menu.)

CONTROLS------------
Player One:
	A/D: Walk Left/Right
	S: Attack
Player Two:
	J/L: Walk Left/Right
	K: Attack 