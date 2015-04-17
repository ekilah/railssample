module UsersHelper

  # Returns the Gravatar URL for the given user.
  def gravatar_url_for(user, size)
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
  end

  # Returns an image tag popuated with the Gravatar URL for the given user.
  def gravatar_image_tag_for(user, options = { size: 80 })
    image_tag(gravatar_url_for(user, options[:size]), alt: user.name, class: "gravatar")
  end

end
