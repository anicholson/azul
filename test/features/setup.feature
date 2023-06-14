Feature: Initial game state for 2 players

Scenario: Initial Scoring
    Given Alice and Bob will play a game
    And Alice is the start player
    When the game starts
    Then Alice's score is 0
    And Bob's score is 0

Scenario: Scorecards
    Given Alice and Bob will play a game
    And Alice is the start player
    When the game starts

#    Then Alice's wall is empty
#    And Bob's wall is empty
#    And Alice's pattern lines are empty
#    And Bob's pattern lines are empty
#    And Alice's floor line is empty
#    And Bob's floor line is empty

#Scenario: the marketplace
#    Given Alice and Bob will play a game
#    And Alice is the start player
#    When the game starts

#    Then there are 5 Factories
#    And each factory is empty
#    And the market center contains only the penalty tile
#    And the bag is full
