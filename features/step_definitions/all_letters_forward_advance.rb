Given(/^I have started the game$/) do
  wait_for_elements_exist( ["view marked:'TitleScene'"] )
  macro 'I touch on screen 200 from the left and 50 from the top'
  check_view_with_mark_exists('A')
end

When(/^I touch the Next Button I see the "(.*?)" view$/) do |letter|
  prev_letter = (letter.codepoints.first - 1).chr
  wait_for_elements_exist(["view marked:'#{prev_letter}'"], {:timeout => 5})
  letter_view = query("view marked:'#{prev_letter}'")[0]
  letter_rect = letter_view["rect"]
  x_touch_point = letter_rect["width"] - 20
  y_touch_point = letter_rect["center_y"]
  sleep 1.0 	# there is a transition, 
  				# so even though we could see the screen before this point, 
  				# we need to wait for the transition to finish before we try and press the button
  touch(nil, :offset => {:x => x_touch_point, :y => y_touch_point})
  wait_for_elements_exist(["view marked:'#{letter}'"], {:timeout => 5})
end
