Given(/^I have started the game$/) do
  wait_for_elements_exist(["view marked:'Title Screen'"])
  touch (["view marked:'Title Screen'"])
  check_view_with_mark_exists('A')
  @current_letter = 'A'
  default_transition_sleep
end

When(/^I touch the Next Button location$/) do
  wait_for_elements_exist([current_letter_query], {:timeout => 5})
  touch_and_wait_for_transitions(letter_rect["width"] - 20, letter_rect["center_y"])
  @current_letter = (@current_letter.codepoints.first + 1).chr
end

When(/^I touch the Previous Button location$/) do
  wait_for_elements_exist([current_letter_query], {:timeout => 5})
  touch_and_wait_for_transitions(letter_rect["x"] + 20, letter_rect["center_y"])
  @current_letter = (@current_letter.codepoints.first - 1).chr
end

When(/^I touch the Letter Select Button location$/) do
  touch_and_wait_for_transitions(30, letter_rect["height"] - 30)
end

def default_transition_sleep
  sleep 1.0
end

def current_letter_query
  "view marked:'#{@current_letter}'"
end

def letter_rect
  letter_view = query(current_letter_query)[0]["rect"]
end

def touch_x_from_left_and_y_from_top(x, y)
  touch(nil, :offset => {:x => x, :y => y})
end

def touch_and_wait_for_transitions(x_touch_point, y_touch_point)
  default_transition_sleep
  touch_x_from_left_and_y_from_top(x_touch_point, y_touch_point)
  default_transition_sleep
end
