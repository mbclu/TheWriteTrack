Given /^I am on the Title Screen$/ do
  element_exists("view")
  sleep(STEP_PAUSE)
end

Then /^the train starts moving$/ do
#  check_element_exists("view marked:'train'")
  #check_element_exists("SKSpriteNode:'train'")
  element_exists("view subview")
end

Then /^It ends in a position off the title screen$/ do
  pending # express the regexp above with the code you wish you had
end