Feature: moving pattern lines to the wall.

Background: a 2-player game of Azul, in the Choosing stage of play.
  Given Alice and Bob will play a game
  And Alice is the start player
  Then the game starts

Scenario: Full pattern lines move to the wall
  Given Alice has pattern lines:
  | line | color | number |
  | 1    | red   | 1      |
  | 2    | red   | 1      |
  | 3    | blue  | 3      |
  | 4    | blank | 0      |
  | 5    | blank | 0      |
  And Alice has an empty wall
  When Alice moves the pattern lines to her wall
  Then Alice now has pattern lines:
  | line | color | number |
  | 1    | blank | 0      |
  | 2    | red   | 1      |
  | 3    | blank | 0      |
  | 4    | blank | 0      |
  | 5    | blank | 0      |
  And row 1 of Alice's wall has a red tile
  And row 3 of Alice's wall has a blue tile
  And 2 blue tiles are added to the box
  But 0 red tiles are added to the box
