class Brand < ActiveRecord::Base

  attr_accessible :brand_name, :brand_user_name, :brand_industry, :fan_size_threshold
  has_many :posts
  has_many :page_level_metrics, :class_name => 'PageLevelMetrics'

                                                          #### Global Metrics Update ####
  def self.global_metrics_update
    brands = Brand.where(:brand_status => true)
    brands.each do |b|
      posts = b.posts
      post_data = posts.where(:post_date => 3.month.ago..Time.now)
    post_digest(post_data)
    end
  end

  def self.post_digest(post_data)
    post_data.each do |p|
      post_id = p.id
      facebook_id = p.post_id
    post_data_pull(post_id, facebook_id, post_data)
    end
  end

  def self.post_data_pull(post_id, facebook_id, post_data)
    insight_array = Array.new
    facebook_insight = HTTParty.get('https://graph.facebook.com/' + facebook_id + '/insights?access_token=' + ENV['ACCESS_TOKEN']).parsed_response['data']
    facebook_insight.each do |p|
      name = p['name']
      value = p['values'][0]['value']
      insight_array << name
      insight_array << value
    end
    post_insight = Hash[*insight_array]
    post_likes_pta = post_insight['post_story_adds_by_action_type_unique']['like']       rescue post_likes_pta = 0
    post_comments_pta = post_insight['post_story_adds_by_action_type_unique']['comment'] rescue post_comments_pta = 0
    post_shares_pta = post_insight['post_story_adds_by_action_type_unique']['share']     rescue post_shares_pta = 0
    post_likes_stories = post_insight['post_story_adds_by_action_type']['like']          rescue post_likes_stories = 0
    post_comments_stories = post_insight['post_story_adds_by_action_type']['comment']    rescue post_comments_stories = 0
    post_shares_stories = post_insight['post_story_adds_by_action_type']['share']        rescue post_shares_stories = 0
    engagement = {'post_likes_pta' => post_likes_pta,               'post_comments_pta' => post_comments_pta,
                  'post_shares_pta' => post_shares_pta,             'post_likes_stories' => post_likes_stories,
                  'post_comments_stories' => post_comments_stories, 'post_shares_stories' => post_shares_stories}
    post_data_update(post_id, post_data, post_insight, engagement)
  end

  def self.post_data_update(post_id, post_data, post_insight, engagement)
    post = Post.find(post_id)
    post.update_attributes(:post_likes_pta =>                             engagement['post_likes_pta'],
                           :post_comments_pta =>                          engagement['post_comments_pta'],
                           :post_shares_pta =>                            engagement['post_shares_pta'],
                           :post_likes_stories =>                         engagement['post_likes_stories/'],
                           :post_comments_stories =>                      engagement['post_comments_stories'],
                           :post_shares_pta =>                            engagement['post_shares_pta'],
                           :post_pta =>                                   post_insight['post_stories'],
                           :post_lifetime_engaged_users =>                post_insight['post_engaged_users'],
                           :post_lifetime_negative_feedback_from_users => post_insight['post_negative_feedback_unique'],
                           :post_lifetime_talking_about_this =>           post_insight['post_storytellers'],
                           :post_organic_impressions =>                   post_insight['post_impressions_organic'],
                           :post_organic_reach =>                         post_insight['post_impressions_organic_unique'],
                           :post_paid_impressions =>                      post_insight['post_impressions_paid'],
                           :post_paid_reach =>                            post_insight['post_impressions_paid_unique'],
                           :post_total_impressions =>                     post_insight['post_impressions'],
                           :post_viral_impressions =>                     post_insight['post_impressions_viral'],
                           :post_total_reach =>                           post_insight['post_impressions_unique'],
                           :total_impressions_from_fans =>                post_insight['post_impressions_fan'],
                           :total_paid_impressions_from_fans =>           post_insight['post_impressions_fan_paid'],
                           :post_viral_reach =>                           post_insight['post_impressions_viral_unique'],
                           :post_consumptions_unique =>                   post_insight['post_consumptions_unique'],
                           :post_consumptions_total =>                    post_insight['post_consumptions'])
  end

                                                          ### Post-level Metrics ###

  def self.new_brand_posts
    puts('Enter the brand id that you want to pull posts for')
      brand_id = gets.chomp.gsub("\n","")
      puts('Thanks! Now what time range would you like to look at? Remember to keep it month-length chunks.')
      puts('Start date: ')
      days_since = gets.chomp.gsub("\n","").to_s
      puts('End Date: ')
      days_now = gets.chomp.gsub("\n","").to_s
      brand = Brand.find(brand_id)
      brand_user_name = brand.brand_user_name
    post_level_data_request(brand_user_name, brand_id, days_since, days_now) unless brand_id.nil?
  end

  def self.fetch_posts
    days_since = (Date.today - 25.days).to_s
    days_now = Date.today.to_s
    brands = Brand.where(:brand_status => true)
    brands.each do |b|
      brand_user_name = b.brand_user_name
      brand_id = b.id
    post_level_data_request(brand_user_name, brand_id, days_since, days_now) unless brand_id.nil?
    end
  end

  def self.post_level_data_request(brand_user_name, brand_id, days_since, days_now)
    post_request = HTTParty.get('https://graph.facebook.com/' + brand_user_name + '/posts?&limit=50&since=' +
    days_since + '&until='+ days_now + '&access_token=' + ENV['ACCESS_TOKEN']).parsed_response['data']
    data_junction(post_request, brand_id, brand_user_name, days_since, days_now)
  end

  def self.new_request(brand_user_name, brand_id, post_request, days_since, days_now)
    notify_me(post_request)
      client_id =
      client_secret =
      grant_type = 'fb_exchange_token'
      fb_exchange_token = ENV['ACCESS_TOKEN']
      new_token = HTTParty.get('https://graph.facebook.com/oauth/access_token?client_id=' + client_id + '&client_secret=' +
                               client_secret + '&grant_type=' + grant_type + '&fb_exchange_token=' + fb_exchange_token).
                               parsed_response[0..-17].sub('access_token=','')
      post_request = HTTParty.get('https://graph.facebook.com/' + brand_user_name + '/posts?&limit=50&since=' +
                                  days_since + '&until='+ days_now + '&access_token=' + new_token).parsed_response['data']
      data_junction(post_request, brand_user_name, brand_id)
  end

  def self.notify_me(post_request)
    puts "Uh Oh..Facebook is being bad (again)"
    NotifyMe.notify_me(post_request).deliver!
  end

  def self.jarvis
    puts "Sending out daily email..."
    JarvisMailer.jarvis_notification(@vm_page).deliver!
  end

  def self.data_junction(post_request, brand_id, brand_user_name, days_since, days_now)
    sleep(15.seconds)
      if post_request.nil?
        new_request(post_request, brand_user_name, brand_id, days_since, days_now)
      else
        data_processor(post_request, brand_id)
      end
  end

  def self.data_processor(post_request, brand_id)
    begin
    post_request.each do |p|
      next if p['status_type'].nil?
      brand_name = p['from']['name']
      facebook_link = p['actions'][1]['link']           rescue next
      post_copy = p['message']
      post_date = p['created_time']
      post_id = p['id']
      post_type = p['type']
      if p['picture'].nil?
        post_thumbnail = p['picture']
      else
        post_thumbnail = p['picture'].gsub('_s','_n')
      end
      metrics = {'brand_name' => brand_name, 'facebook_link' => facebook_link, 'post_copy' => post_copy, 'post_date' => post_date,
                 'post_id' => post_id, 'post_type' => post_type, 'post_thumbnail' => post_thumbnail}
      insights_request(metrics, brand_id)
      end
    end
  end

  def self.thumbnail_method
    posts = Post.where(:post_thumbnail => nil)
    posts.each do |p|
      post_id = p.post_id
      thumbnail = HTTParty.get('https://graph.facebook.com/' + post_id + '/?access_token=' + ENV['ACCESS_TOKEN']).parsed_response['picture']
    thumbnail_save(thumbnail, post_id)
    end
  end

  def self.thumbnail_save(thumbnail, post_id)
    post = Post.find_by_post_id(post_id)
    post.update_attributes(:post_thumbnail => thumbnail)
  end

  def self.post_level_job
    posts = Post.where(:post_total_reach => nil)
    posts.each do |p|
      post_id = p.post_id
    post_insights_request = HTTParty.get('https://graph.facebook.com/' + post_id + '/insights?access_token=' + ENV['ACCESS_TOKEN']).parsed_response['data']
    insights_processor(post_insights_request, post_id)
    end
  end

  def self.insights_request(metrics, brand_id)
    post_insights_request = HTTParty.get('https://graph.facebook.com/' + metrics['post_id'] + '/insights?access_token=' + ENV['ACCESS_TOKEN']).parsed_response['data']
    insights_junction(post_insights_request, metrics, brand_id)
  end

  def self.insights_junction(post_insights_request, metrics, brand_id)
    if post_insights_request.nil?
      puts post_insights_request
      sleep(10.minutes)
      insights_request(metrics)
    else
      insights_processor(post_insights_request, metrics, brand_id)
    end
  end

  def self.insights_processor(post_insights_request, metrics, brand_id)
    insight_data = Array.new
    post_insights_request.each do |i|
      name = i['name']
      value = i['values'][0]['value']
      insight_data << name
      insight_data << value
    end
    insight = Hash[*insight_data]
    engagement_processing(metrics, brand_id, insight)
  end

  def self.engagement_processing(metrics, brand_id, insight)
    begin
      post_likes_pta = insight['post_story_adds_by_action_type_unique']['like']       rescue post_likes_pta = 0
      post_comments_pta = insight['post_story_adds_by_action_type_unique']['comment'] rescue post_comments_pta = 0
      post_shares_pta = insight['post_story_adds_by_action_type_unique']['share']     rescue post_shares_pta = 0
      post_likes_stories = insight['post_story_adds_by_action_type']['like']          rescue post_likes_stories = 0
      post_comments_stories = insight['post_story_adds_by_action_type']['comment']    rescue post_comments_stories = 0
      post_shares_stories = insight['post_story_adds_by_action_type']['share']        rescue post_shares_stories = 0
      engagement = {'post_likes_pta' => post_likes_pta,               'post_comments_pta' => post_comments_pta,
                    'post_shares_pta' => post_shares_pta,             'post_likes_stories' => post_likes_stories,
                    'post_comments_stories' => post_comments_stories, 'post_shares_stories' => post_shares_stories}
      data_processing(metrics, brand_id, insight, engagement)
    end
  end

  def self.new_metric_init
    puts('Enter the new metric you want using Facebooks API strucure (ex: "post_impressions_viral"): ')
    puts('Also, remember to create the column FIRST, and also make sure it is migrated properly')
      metric_name = gets.chomp.gsub("\n","")
    puts('What is the metric name that is in the db? ')
      db_metric_name = gets.chomp.gsub("\n","")
    new_metric_retrieval(metric_name, db_metric_name)
  end

  def self.new_metric_retrieval(metric_name, db_metric_name)
    posts = Post.where(:"#{db_metric_name}" => nil)
    puts('There are currently ' + "#{posts.count}" + ' posts that are missing ' + db_metric_name + ' metrics.')
    posts.each do |p|
      post_id = p.post_id
      brand_id = p.brand_id
    new_metric_request(post_id, brand_id, db_metric_name, metric_name) unless post_id.nil?
    end
  end

  def self.new_metric_request(post_id, brand_id, db_metric_name, metric_name)
    metric_request = HTTParty.get('https://graph.facebook.com/' + post_id + '/insights/' + metric_name + '?access_token=' + ENV['ACCESS_TOKEN']).parsed_response['data']
    if metric_request[0].nil?
      puts 'No access'
    else
      metric_value =  metric_request[0]['values'][0]['value']
     new_metric_junction(post_id, brand_id, metric_value, metric_request, db_metric_name)
    end
  end

  def self.new_metric_junction(post_id, brand_id, metric_value, metric_request, db_metric_name)
    if metric_request.nil?
      new_request_for_new_metric(post_id, brand_id, metric_value, metric_request, db_metric_name)
    else
      new_metric_if_empty(post_id, brand_id, metric_value, db_metric_name)
    end
  end

  def self.new_metric_if_empty(post_id, brand_id, metric_value, db_metric_name)
    if metric_value.nil?
      metric_value = 0
    else
      new_metric_append(post_id, brand_id, metric_value, db_metric_name)
    end
  end

  def self.new_request_for_new_metric(post_id, brand_id, metric_value, metric_request, db_metric_name)
      client_id =
      client_secret =
      grant_type = 'fb_exchange_token'
      fb_exchange_token = ENV['ACCESS_TOKEN']
      new_token = HTTParty.get('https://graph.facebook.com/oauth/access_token?client_id=' + client_id + '&client_secret=' +
                               client_secret + '&grant_type=' + grant_type + '&fb_exchange_token=' + fb_exchange_token).
                               parsed_response[0..-17].sub('access_token=','')
      metric_request = HTTParty.get('https://graph.facebook.com/' "#{post_id}"  '/insights/' "#{metric_value}" '?access_token=' + new_token).parsed_response
      new_metric_junction(post_id, brand_id, metric_value, metric_request, db_metric_name)
  end

  def self.new_metric_append(post_id, brand_id, metric_value, db_metric_name)
    new_metric_request_init = Post.find_by_post_id(post_id)
    new_metric_request_init.update_attributes(:"#{db_metric_name}" =>     metric_value)
  end

                        #### Importing tags from Stamprr into the system here #####

  def self.post_level_tags_from_stamprr_pull
    brands = Brand.where(:brand_status => true)
    brands.each do |b|
      brand_user_name = b.brand_user_name
    posts_iteration(brand_user_name)
    end
  end

  def self.posts_iteration(brand_user_name)
    posts = HTTParty.get('TAGGING APP API LINK').parsed_response
    posts.each do |p|
      post_id = p['id']
      primary_tags = p['primary_tags']
      secondary_tags = p['secondary_tags']
    tag_iteration(post_id, primary_tags, secondary_tags)
    end
  end

  def self.tag_iteration(post_id, primary_tags, secondary_tags)
    begin
    post = Post.find_by_post_id(post_id)
    post.update_attributes(:primary_tags =>   primary_tags,
                           :secondary_tags => secondary_tags)
    rescue
    end
  end

  def self.data_processing(metrics, brand_id, insight, engagement)
    database_processor = Brand.find(brand_id).posts.find_or_create_by_post_id(metrics['post_id'])
    database_processor.update_attributes(:brand_name =>                                   metrics['brand_name'],
                                         :facebook_link =>                                metrics['facebook_link'],
                                         :post_type =>                                    metrics['post_type'],
                                         :post_copy =>                                    metrics['post_copy'],
                                         :post_date =>                                    metrics['post_date'],
                                         :post_id =>                                      metrics['post_id'],
                                         :post_thumbnail =>                               metrics['post_thumbnail'],
                                         :post_likes_pta =>                               engagement['post_likes_pta'],
                                         :post_comments_pta =>                            engagement['post_comments_pta'],
                                         :post_shares_pta =>                              engagement['post_shares_pta'],
                                         :post_likes_stories =>                           engagement['post_likes_stories'],
                                         :post_comments_stories =>                        engagement['post_comments_stories'],
                                         :post_shares_stories =>                          engagement['post_shares_stories'],
                                         :post_pta =>                                     insight['post_stories'],
                                         :post_lifetime_engaged_users =>                  insight['post_engaged_users'],
                                         :post_lifetime_negative_feedback_from_users =>   insight['post_negative_feedback_unique'],
                                         :post_lifetime_talking_about_this =>             insight['post_storytellers'],
                                         :post_organic_impressions =>                     insight['post_impressions_organic'],
                                         :post_organic_reach =>                           insight['post_impressions_organic_unique'],
                                         :post_paid_impressions =>                        insight['post_impressions_paid'],
                                         :post_paid_reach =>                              insight['post_impressions_paid_unique'],
                                         :post_total_impressions =>                       insight['post_impressions'],
                                         :post_viral_impressions =>                       insight['post_impressions_viral'],
                                         :post_total_reach =>                             insight['post_impressions_unique'],
                                         :total_impressions_from_fans =>                  insight['post_impressions_fan'],
                                         :total_paid_impressions_from_fans =>             insight['post_impressions_fan_paid'],
                                         :post_viral_reach =>                             insight['post_impressions_viral_unique'],
                                         :post_consumptions_unique =>                     insight['post_consumptions_unique'],
                                         :post_consumptions_total =>                      insight['post_consumptions'],
                                         :brand_id =>                                     brand_id)

  end

                                              ### Page-level Metrics ###
  def self.new_brand_page_level_pull
    puts('Enter the brand id that you want to pull page-level metrics for: ')
    brand_id = gets.chomp.gsub("\n", "")
    brand_user_name = Brand.find(brand_id).brand_user_name
    page_level_metrics_data_retrival(brand_id, brand_user_name)
  end

  def self.page_level_pull
    brands = Brand.where(:brand_status => true)
    brands.each do |b|
     brand_id = b.id
     brand_user_name = b.brand_user_name
    page_level_metrics_data_retrival(brand_id, brand_user_name) unless brand_id.nil?
    end
  end

  def self.page_level_metrics_data_retrival(brand_id, brand_user_name)
    page_level_metrics = Hash.new
    values = Array.new
    page_metrics = ['page_fans','page_posts_impressions/days_28', 'page_posts_impressions_organic_unique/days_28', 'page_posts_impressions_viral_unique/days_28']
      page_metrics.each do |m|
        page_level_request = HTTParty.get('https://graph.facebook.com/' + brand_user_name +
                                          '/insights/' + m + '?access_token=' + ENV['ACCESS_TOKEN'] +
                                          '&since=2013-01-01&until=2013-02-01').parsed_response
        puts page_level_request
        values << page_level_request['data'][0]['values'] unless page_level_request['data'][0].nil?
          while page_level_request['data'].count > 0 do
            page_level_request = HTTParty.get(page_level_request['paging']['next']).parsed_response
            values << page_level_request['data'][0]['values'] unless page_level_request['data'][0].nil?
          end
            page_level_metrics = {"#{m}" => values}
            values = Array.new
        page_level_parser(brand_id, brand_user_name, page_level_metrics, m)
      end
  end

  def self.page_level_parser(brand_id, brand_user_name, page_level_metrics, m)
    page_level_metrics["#{m}"].each do |a|
      a.each do |p|
        fb_date = p['end_time']
        date = Time.parse(fb_date.slice(0..(fb_date.index('T'))).sub('T','')).strftime("%F")
    page_level_init = Brand.find(brand_id).page_level_metrics.find_or_create_by_page_level_date(date)
    page_level_init.update_attributes(:brand_id =>                                         brand_id,
                                      :brand_name =>                                       brand_user_name,
                                      :page_level_date =>                                  date)
        case("#{m}")
          when 'page_posts_impressions_organic_unique/days_28'
            page_level_init.update_attributes(:twenty_eight_day_reach_of_page_posts_organic =>    p['value'])
          when 'page_posts_impressions_viral_unique/days_28'
            page_level_init.update_attributes(:twenty_eight_day_reach_of_page_posts_viral =>      p['value'])
          when 'page_posts_impressions/days_28'
            page_level_init.update_attributes(:twenty_eight_day_total_impressions_of_page_posts =>p['value'])
          when 'page_fans'
            page_level_init.update_attributes(:page_size =>                                       p['value'])
        end
      end
    end
  end

end
