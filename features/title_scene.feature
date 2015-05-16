Feature: Starting the game
  As a child using the application
  I want to have a fun title screen with a button to press
  So I can begin playing the game

Scenario: The Letter A game level is loaded upon press of the Start Button
  Given I see the "TitleScene"
  When I touch on screen 200 from the left and 50 from the top
  Then I see the "A"
