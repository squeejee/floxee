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
  
  def twitter_status_path(screen_name, status_id)
    "http://twitter.com/#{screen_name}/status/#{status_id}"
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
  
  def detail_link_for_user(user, text=user.display_name)
    if user.person
      link_to text, detail_path_for_user(user), :class => 'username', :title => user.person.display_name
      
    # elsif user.organization
    #       link_to "#{user.organization.display_name} #{extra_text}", detail_path_for_user(user), :class => 'username', :title => user.organization.display_name
    else
      link_to text, detail_path_for_user(user)
    end
  end
  
  def detail_path_for_user(user)
    if user.person
      person_path(user.person)
    # elsif user.organization
    #   organization_path(user.organization)
    else
      user_path(user)
    end
  end
  
  def detail_link_for_tweet(tweet)
    if tweet.person
      link_to tweet.person.display_name, person_path(tweet.person), :class => 'username', :title => tweet.person.display_name
    # elsif tweet.organization
    #       link_to tweet.organization.display_name, organization_path(tweet.organization), :class => 'username', :title => tweet.organization.display_name
    else
      link_to tweet.user.screen_name, twitter_user_url(tweet.user.screen_name), :class => 'username', :title => tweet.user.name
    end
  end
  
  def follow_user_link(user, text=t('follow'), options={})
    opts = {:class => 'button small dark'}
    opts.merge!(options)
    link_to(text, follow_user_path(user), opts) unless (logged_in? and current_user == user)
  end
  
  def follow_person_link(person, text=t('follow'), options={})
    opts = {:class => 'button small dark'}
    opts.merge!(options)
    link_to(text, follow_person_path(person), opts) unless (logged_in? and current_user == person.user)
  end
  
  def icon(filename)
    image_tag('/images/icons/fugue/' + filename + '.png')
  end
end
