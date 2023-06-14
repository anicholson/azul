Feature: Choosing tiles from a factory

Scenario: Alice chooses tiles from the factory that fit
    Given Alice and Bob will play a game
    And Alice is the start player
    Then the game starts
    Given the factories are all full
    And factory 2 has tiles:
    | color | count |
    | blue  | 1     |
    | red   | 1     |
    | black | 0     |
    | white | 2     |
    | yellow| 0     |
    And Alice is the active player
    When Alice chooses white tiles from factory 2
    And chooses to place them on row 2 of their pattern line
    And takes her turn
    Then their turn ends
    And the tiles are moved to their pattern line
    And the factory is empty
    And the remaining tiles are moved to the center
    And Bob is the active player
 

Scenario: Alice chooses more tiles from the factory than will fit
    Given the factories are all full
    And factory 2 has tiles:
    | color | count |
    | blue  | 1     |
    | red   | 1     |
    | black | 0     |
    | white | 2     |
    | yellow| 0     |
    And Alice is the active player
    And row 2 of their pattern line has 1 white tile
    When Alice chooses white tiles from factory 2
    And chooses to place them on row 2 of their pattern line
    And takes her turn
    Then row 2 of their pattern line is full
    But their floor line has 1 tile
    And their turn ends
    Then the factory is empty
    And the remaining tiles are moved to the center
    And Bob is the active player


Scenario: Choosing tiles from the center and collecting the penalty tile
    Given the factories are empty
    But the center has tiles:
    | color | count |
    | blue  | 4     |
    | red   | 2     |
    | black | 3     |
    | white | 3     |
    | yellow| 0     |
    And the center has the penalty tile
    And Alice is the active player
    When Alice chooses blue tiles from the center
    And chooses to place them on row 5 of their pattern line
    And takes her turn
    Then their turn ends
    And the tiles are moved to their pattern line
    And the penalty tile is moved to their floor line
    And the center now has tiles:
    | color | count |
    | blue  | 0     |
    | red   | 2     |
    | black | 3     |
    | white | 3     |
    | yellow| 0     |
    But the center no longer has the penalty tile
    Then Bob is the active player
    When Bob chooses black tiles from the center
    And chooses to place them on row 5 of their pattern line
    And takes his turn
    Then their turn ends
    And the tiles are moved to their pattern line
    But the penalty tile is not moved to their floor line
    And the center now has tiles:
    | color | count |
    | blue  | 0     |
    | red   | 2     |
    | black | 0     |
    | white | 3     |
    | yellow| 0     |
