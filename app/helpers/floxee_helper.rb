# Methods added to this helper will be available to all templates in the application.
module FloxeeHelper
  def twitter_auto_link(text)
    text = auto_link(text)
    # autolink @ tags reference people in Tweets
    text.gsub!(/(^|\s)(@)(\w+)/, '\1<a href="http://twitter.com/\3">\2\3</a>')
    # autolinke hash tags
    text.gsub(/(^|\s)(#)(\w+)/, '\1<a href="http://search.twitter.com/search?q=%23\3">\2\3</a>')    
  end
  
  def twitter_user_url(screen_name)
    "http://twitter.com/#{screen_name}"
  end
  
  def twitter_user_friends_url(screen_name)
    "#{twitter_user_url(screen_name)}/friends"
  end

  def twitter_user_followers_url(screen_name)
     "#{twitter_user_url(screen_name)}/followers"
  end
  
  def twitter_status_path(status)
    "http://twitter.com/#{status.user.screen_name}/status/#{status.id}"
  end
  
  def twitter_profile_image(twitter_user, options={})
    return if twitter_user.profile_image_url.blank?
    opts = {:class => 'avatar', :size => '36x36'}
    opts.merge!(options)
    image_tag(twitter_user.profile_image_url, opts)
  end
  
  def user_profile_image_path(size='mini')
    return unless logged_in?
    path = current_user.profile_image_url
    path.gsub('_normal.', "_#{size}.")
  end
  
  def user_profile_image(size='mini', options={})
    return unless logged_in?
    image_tag(user_profile_image_path(size), options)
  end
  
  def detail_link_for_tweet(tweet)
    if tweet.person
      link_to tweet.person.display_name, person_path(tweet.person)
    elsif tweet.organization
      link_to tweet.organization.display_name, organization_path(tweet.organization)
    else
      link_to tweet.user.screen_name, twitter_user_url(tweet.user.screen_name)
    end
  end
  
  def icon(filename)
    image_tag('/images/icons/fugue/' + filename + '.png')
  end
end
