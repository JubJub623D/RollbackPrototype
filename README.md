# RollbackPrototype
A barebones prototype of a fighting game written in GDScript (Godot's scripting language) that aims to incorporate rollback netcode by integrating GGPO. 
Rollback works to decrease the effects of latency on input timing by ignoring delay using predictive inputs. If any of the predicted inputs do not match to the actual, delayed inputs when they arrive, the gamestate rolls back (hence the name) and resimulates itself using the actual inputs, updating to the correct gamestate as soon as possible after the actual inputs arrive.

![rollback_diagram](https://user-images.githubusercontent.com/41028399/160308341-fb4d0c51-254a-402c-b0d9-659868e41a64.png)

### CONTROLS: 
The mouse and left-click buttons are used to navigate menus. When in the Online Versus menu, the keyboard will be necessary to set IP, port, and desired delay frames.

Player One:
- A/D: Walk Left/Right
- S: Attack

Player Two:
- J/L: Walk Left/Right
- K: Attack 
  
### WHY:
Rollback netcode necessitates a few key design elements in the game's inner workings, which is why it can be difficult and time-consuming to retrofit rollback into pre-existing designs (ie: NetherRealm Studios took about 10-months to retrofit rollback netcode into Mortal Kombat X, consuming 8 man-years' worth of effort). The goal of this project was to gain a spurious, but nevertheless working understanding of the kind of design considerations that need to be made when creating a game with rollback netcode from the ground up.

Necessary Design Elements:
- Fully deterministic state: The game should put out a consistent output gamestate given any given pair of input gamestate and player inputs. Otherwise, there could be desyncs between the players whenever a rollback occurs and the two ends simulate their gamestate differently. 
- Low-cost state-resimulation: Whenever the game receives inputs that force it to rollback, the corrected gamestate should be shown to the player on the next frame. To achieve this, gamestate resimulation should be as resource-light and quick as possible. Preferably, resimulating the state should be divorced from any front-end updates until the state is fully resimulated. 

### HOW:
The rollback integration in this game was made possible by the original open-source GGPO SDK and FlutterTal's GodotGGPO module.

### FUTURE IMPROVEMENTS:
 - Get rid of the cause of leaked StreamBuffers once the GGPO connection is closed.
For a reason unknown to me, whenever RollbackPrototype closes a GGPO connection, eight StreamBuffers leak, meaning that they are not properly deallocated before the GGPO connection is closed. This seems peculiar, because GGPO should automatically close any allocated buffers using a callback event that activates whenever the connection is closed. This is the number one priority to fix, as it seems unacceptable that playing online should consistently leak resources.
 - Replace the floating-point positional math with fixed-point math, allowing for perfect determinism.
As floating-point math is not perfectly deterministic across different systems, it is possible (even if improbable) for differences in floating-point calculations to cause desyncs between two connected gamestates. To reduce the possible causes for desyncs, I need to find a way to reconfigure Godot Engine's physics to use fixed-point math, which is perfectly deterministic across different systems.
