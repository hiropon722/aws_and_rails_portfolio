require "test_helper"

class TypingGameControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get typing_game_index_url
    assert_response :success
  end
end
