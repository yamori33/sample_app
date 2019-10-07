require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    # 登録ページにアクセス
    get signup_path
    # POSTリクエストの送信前後でUserの数が変化しないことをテスト
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "foo",
                                         password_confirmation: "bar" } }
    end
    # 登録失敗時にnewアクションが再描画されることをテスト
    assert_template 'users/new'
    # エラーメッセージが表示されることをテスト
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    
    assert_select 'form[action="/signup"]'
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password: "password",
                                         password: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
