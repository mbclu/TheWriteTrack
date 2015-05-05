Feature: Running a test
  As a child using the application
  I want to have a fun title screen
  So I can begin playing the game

Scenario: Letter A is presented upon press of the Start button
  Given I see the "TitleScene"
  When I touch on screen 200 from the left and 50 from the top
  Then I see the "A"
  