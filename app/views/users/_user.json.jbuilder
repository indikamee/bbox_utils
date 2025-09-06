json.extract! user, :id, :provider, :uid, :name, :location, :image_url, :url, :password, :autocalc, :created_at, :updated_at
json.url user_url(user, format: :json)
