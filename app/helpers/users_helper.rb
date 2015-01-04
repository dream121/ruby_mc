require 'digest/md5'

module UsersHelper

  def user_avatar(user)
    if facebook = user.facebook
      if facebook.info && facebook.info['image']
        image_url = facebook.info['image']
      end
    else
      image_url = gravatar_url(user.email)
    end
    image_tag image_url
  end

  def user_avatar_large(user)
    if facebook = user.facebook
      if facebook.info && facebook.info['image']
        image_url = facebook.info['image']
      end
    else
      image_url = gravatar_url(user.email)
      image_url += "&s=108"
    end
    image_tag image_url 
  end

  def gravatar_url(email)
    hash = Digest::MD5.hexdigest(email.downcase)
    "#{request.protocol}www.gravatar.com/avatar/#{hash}?s=50&d=identicon"
  end
end
