Feature: Choosing tiles from a factory

Scenario: Player chooses tiles from the factory that fit
    Given Alice and Bob will play a game
    And Alice is the start player
    Then the game starts
    And Alice is the active player
    When factory 2 has tiles:
    | color | count |
    | blue  | 1     |
    | red   | 1     |
    | black | 0     |
    | white | 2     |
    | yellow| 0     |
    And Alice chooses white tiles from factory 2
    And places them on row 3 of her pattern lines
    And takes her turn
    Then we debug