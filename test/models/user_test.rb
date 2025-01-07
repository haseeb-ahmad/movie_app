require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not save user without email" do
    user = User.new(password: 'password', password_confirmation: 'password')
    assert_not user.save, "Saved the user without an email"
  end

  test "should not save user without password" do
    user = User.new(email: 'user@example.com')
    assert_not user.save, "Saved the user without a password"
  end

  test "should save user with valid email and password" do
    user = User.new(email: 'user@example.com', password: 'password', password_confirmation: 'password')
    assert user.save, "Failed to save the user with valid email and password"
  end

  test "should not save user with duplicate email" do
    user1 = User.new(email: 'user@example.com', password: 'password', password_confirmation: 'password')
    user1.save
    user2 = User.new(email: 'user@example.com', password: 'password', password_confirmation: 'password')
    assert_not user2.save, "Saved the user with duplicate email"
  end
end
