Feature: Running a test
  As a child using the application
  I want to have a fun title screen
  So I can begin testing quickly

Scenario: Train moves across the title screen
  Given I am on the Title Screen
  Then the train starts moving
  And It ends in a position off the title screen
  