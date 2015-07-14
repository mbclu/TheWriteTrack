Feature: Advancing through all of the letters

  Scenario: Each of the Capital letter levels can be reached in sequence by pressing the Next Button
    Given I have started the game
    When I touch the Next Button I see the "B" view
    When I touch the Next Button I see the "C" view
    When I touch the Next Button I see the "D" view
    When I touch the Next Button I see the "E" view
    When I touch the Next Button I see the "F" view
    When I touch the Next Button I see the "G" view
    When I touch the Next Button I see the "H" view
    When I touch the Next Button I see the "I" view
    When I touch the Next Button I see the "J" view
    When I touch the Next Button I see the "K" view
    When I touch the Next Button I see the "L" view
    When I touch the Next Button I see the "M" view
    When I touch the Next Button I see the "N" view
    When I touch the Next Button I see the "O" view
    When I touch the Next Button I see the "P" view
    When I touch the Next Button I see the "Q" view
    When I touch the Next Button I see the "R" view
    When I touch the Next Button I see the "S" view
    When I touch the Next Button I see the "T" view
    When I touch the Next Button I see the "U" view
    When I touch the Next Button I see the "V" view
    When I touch the Next Button I see the "W" view
    When I touch the Next Button I see the "X" view
    When I touch the Next Button I see the "Y" view
    When I touch the Next Button I see the "Z" view

  Scenario: The previously played letter can be reached by pressing the Previous Button
    Given I have started the game
    When I touch the Next Button I see the "B" view
    When I touch the Previous Button I see the "A" view