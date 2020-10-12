ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :email, :encrypted_password, :name, :avatar_url, :reset_password_token, :reset_password_sent_at, :remember_created_at
  #
  # or
  #
  # permit_params do
  #   permitted = [:email, :encrypted_password, :name, :avatar_url, :reset_password_token, :reset_password_sent_at, :remember_created_at]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  index do
    column "Likes" do |post|
      post.likes.count
    end
    column "Tweets" do |post|
      post.tweets.count
    end
    column "Retweets" do |post|
      post.tweets.count
    end
    column "Follows" do |post|
      post.tweets.count
    end
    User.column_names.each do |c|
      column c.to_sym
    end
    actions
  end
end