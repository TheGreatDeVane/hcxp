require 'rubygems'
require 'mechanize'
require 'nokogiri'

module Khcpl
  class InvalidCredentials < ArgumentError; end

  class Fhcpl
    def self.get_profile_info(user_name, user_password)
      agent = Mechanize.new
      page  = agent.get('http://forum.hard-core.pl/ucp.php?mode=login')
      Rails.logger.info 'Front page loaded.'

      sign_in_form = page.forms.second

      sign_in_form.username = user_name
      sign_in_form.password = user_password
      Rails.logger.info 'Filled sign-in form.'

      page = agent.submit(sign_in_form, sign_in_form.buttons.first)
      Rails.logger.info "Submited sign-in form"

      if page.body.include? 'ucp.php?mode=logout'
        Rails.logger.info 'Found log-out link'
        Rails.logger.info 'Signed in successfully'
      else
        raise Khcpl::InvalidCredentials, 'Wrong username or password'
      end

      page = agent.get('http://forum.hard-core.pl/ucp.php?i=profile&mode=reg_details')
      Rails.logger.info 'Loaded setup details page'

      user_email = page.form('ucp').email
      Rails.logger.info "Email obtained (#{user_email})"

      page = agent.get('http://forum.hard-core.pl')
      Rails.logger.info "Going back to home page to get the ID"

      profile_link = Nokogiri::HTML(page.body).at('.gensmall a:contains("m.b.")').attributes['href'].value
      Rails.logger.info 'Profile link obtained'

      user_id = profile_link.scan(/\d/).join('')
      Rails.logger.info "Profile ID obtained (#{user_id})"

      return { user_name: user_name, user_email: user_email, user_id: user_id, provider: 'khcpl' }
    end
  end
end