require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
  end
  
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      # 非管理者にはdeleteが表示されていることを確認
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    # 非管理者を削除し、ユーザー数が1減ることを確認
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end
  
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    # 非管理者からはdelteが見えていないことを確認
    assert_select 'a', text: 'delete', count: 0
  end
end
