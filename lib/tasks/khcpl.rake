require 'rubygems'
require 'mechanize'
require 'nokogiri'

class InvalidCredentials < ArgumentError; end

namespace :khcpl do

  desc "Sign in to forum.hard-core.pl"
  task sign_in: :environment do
    begin
      agent         = Mechanize.new
      user_name     = 'm.b.'
      user_password = 'CI2JNVAE'

      page = agent.get('http://forum.hard-core.pl/')
      puts '* Front page loaded.'

      sign_in_form = page.forms.second

      sign_in_form.username = user_name
      sign_in_form.password = user_password
      puts '* Filled sign-in form.'

      page = agent.submit(sign_in_form, sign_in_form.buttons.first)
      puts '* Submited sign-in form.'

      if page.body.include? 'ucp.php?mode=logout'
        puts '* Found log-out link'
        puts '* Signed in successfully'
      else
        raise InvalidCredentials
      end

      page = agent.get('http://forum.hard-core.pl/ucp.php?i=profile&mode=reg_details')
      puts '* Loaded setup details page'

      user_email = page.form('ucp').email
      puts "* Email obtained (#{user_email})"

      page = agent.get('http://forum.hard-core.pl')
      puts "* Going back to home page to get the ID"
      
      profile_link = Nokogiri::HTML(page.body).at('.gensmall a:contains("m.b.")').attributes['href'].value
      puts '* Profile link obtained'

      user_id = profile_link.scan(/\d/).join('').to_i
      puts "* Profile ID obtained (#{user_id})"

      puts "* Done. Username: #{user_name}, email: #{user_email}, password: #{user_password}, ID: #{user_id}, provider: khcpl"

    rescue InvalidCredentials
      puts '* Wrong username or password'
    end
  end

end
