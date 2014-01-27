
  desc 'This task is going to fetch posts from Facebook API'

    task :fetch_posts => :environment do
      puts 'Fetching facebook data for all of our accounts...'
      Brand.fetch_posts
      puts 'All done!'
    end

  desc 'This is going to send an email out to everyone'

    task :email_status => :environment do
      puts 'Running the old jarvis babes...'
      Brand.jarvis
      puts 'SENT!'
    end

  desc 'This is going to pull page-level metrics'

    task :page_level_metrics => :environment do
      puts 'Pulling page level metrics'
      Brand.page_level_pull
      puts 'DONE!'
    end

  desc 'This is going to pull tags for each post'

    task :tags_per_post => :environment do
      puts 'Pulling tags for each post'
      Brand.post_level_tags_from_stamprr_pull
      puts 'DONE!'
    end
