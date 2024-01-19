json.array!(@tweets) do |tweet|
  json.id tweet.id
  json.message tweet.message
  json.created_at tweet.created_at
  json.user do
    json.id tweet.user.id
    json.username tweet.user.username
    # Add other user attributes as needed
  end
end
