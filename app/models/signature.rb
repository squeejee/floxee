class Signature < CouchRest::ExtendedDocument
  # include Floxee::TwitterMethods
  # 
  # property :twitter_screen_name
  # property :twitter_user, :cast_as => 'TwitterUser'
  # 
  # 
  # def self.sign
  #       
  #   last_twitter_id = Signature.maximum :twitter_status_id          
  #   
  #   tweets = Twitter::Search.new.hashed("floxee").since(last_twitter_id).fetch()["results"]
  #   
  #   tweets.each do |tweet|
  #     hash_match = tweet["text"].match(/#..-.{1,2}/)
  #     unless hash_match.nil?
  #       hash_tag = hash_match[0] 
  #       official = Official.find_by_hash_tag(hash_tag)
  #       
  #       if petition = official.petitions.first
  #         existing_twitter_ids = petition.signatures.collect{|s| s.twitter_id}
  #         twitter_id = tweet["from_user"]
  #         unless existing_twitter_ids.include?(twitter_id)
  #           signature = petition.signatures.build
  #           signature.twitter_id = twitter_id
  #           signature.twitter_profile_image_url = tweet["profile_image_url"]
  #           signature.note = tweet["text"]
  #           signature.twitter_status_id = tweet["id"]
  #           if signature.save
  #             petition.update_attribute('updated_at', Time.now)
  #           end
  #         end
  #       end unless official.nil?
  #     end
  #   end
  # end
  # 
end
