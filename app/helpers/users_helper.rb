module UsersHelper

  # Returns the Gravatar URL for the given user.
  def gravatar_url_for(user)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}"
  end

  # Returns an image tag popuated with the Gravatar URL for the given user.
  def gravatar_image_tag_for(user)
    image_tag(gravatar_url_for(user), alt: user.name, class: "gravatar")
  end

end
