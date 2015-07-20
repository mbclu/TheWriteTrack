Feature: Advancing through all of the letters

  Scenario: The Letter A game level is loaded upon press of the screen
    Given I see the "Title Screen"
    When I touch "Title Screen"
    Then I see the "A"

  Scenario: Each of the Capital letter levels can be reached in sequence
    Given I have started the game
    When I touch the Next Button location
    Then I see the "B"
    When I touch the Next Button location
    Then I see the "C"
    When I touch the Next Button location
    Then I see the "D"
    When I touch the Next Button location
    Then I see the "E"
    When I touch the Next Button location
    Then I see the "F"
    When I touch the Next Button location
    Then I see the "G"
    When I touch the Next Button location
    Then I see the "H"
    When I touch the Next Button location
    Then I see the "I"
    When I touch the Next Button location
    Then I see the "J"
    When I touch the Next Button location
    Then I see the "K"
    When I touch the Next Button location
    Then I see the "L"
    When I touch the Next Button location
    Then I see the "M"
    When I touch the Next Button location
    Then I see the "N"
    When I touch the Next Button location
    Then I see the "O"
    When I touch the Next Button location
    Then I see the "P"
    When I touch the Next Button location
    Then I see the "Q"
    When I touch the Next Button location
    Then I see the "R"
    When I touch the Next Button location
    Then I see the "S"
    When I touch the Next Button location
    Then I see the "T"
    When I touch the Next Button location
    Then I see the "U"
    When I touch the Next Button location
    Then I see the "V"
    When I touch the Next Button location
    Then I see the "W"
    When I touch the Next Button location
    Then I see the "X"
    When I touch the Next Button location
    Then I see the "Y"
    When I touch the Next Button location
    Then I see the "Z"

  Scenario: The previously played letter can be reached
    Given I have started the game
    When I touch the Next Button location
    Then I see the "B"
    When I touch the Previous Button location
    Then I see the "A"

  Scenario: There is no previous screen from A
    Given I have started the game
    When I touch the Previous Button location
    Then I see the "A"
