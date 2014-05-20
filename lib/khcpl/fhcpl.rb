require 'rubygems'
require 'mechanize'
require 'nokogiri'

module Khcpl
  class InvalidCredentials < ArgumentError; end
  class NoProfileLinkFound < ArgumentError; end
  class NoUserIdFound      < ArgumentError; end

  class Fhcpl
    def initialize(user_name, password)
      @user_name = user_name
      @password  = password
    end

    def get_profile_info()
      agent = Mechanize.new

      sign_in(agent)
      get_email(agent)
      get_profile_link(agent)
      get_user_id

      return {
        user_name:  @user_name,
        user_email: @email,
        user_id:    @user_id,
        provider:   'khcpl'
      }
    end

    private

      def sign_in(agent)
        page  = agent.get('http://forum.hard-core.pl/ucp.php?mode=login')
        Rails.logger.info 'Front page loaded.'

        sign_in_form = page.forms.second

        sign_in_form.username = @user_name
        sign_in_form.password = @password
        Rails.logger.info 'Filled sign-in form.'

        page = agent.submit(sign_in_form, sign_in_form.buttons.first)
        Rails.logger.info "Submited sign-in form"

        if page.body.include? 'ucp.php?mode=logout'
          Rails.logger.info 'Found log-out link'
          Rails.logger.info 'Signed in successfully'
        else
          fail Khcpl::InvalidCredentials, 'Wrong username or password'
        end
      end

      def get_email(agent)
        page = agent.get('http://forum.hard-core.pl/ucp.php?i=profile&mode=reg_details')
        Rails.logger.info 'Loaded setup details page'

        user_email = page.form('ucp').email

        if user_email.present?
          Rails.logger.info "Email obtained (#{user_email})"
          @email = user_email
        else
          fail Khcpl::NoEmailFound, 'Email has not been found'
        end
      end

      def get_profile_link(agent)
        page = agent.get('http://forum.hard-core.pl')
        Rails.logger.info "Going back to home page to get the ID"

        profile_link = Nokogiri::HTML(page.body).at(".gensmall a:contains('#{@user_name}')").attributes['href'].value

        if profile_link.present?
          Rails.logger.info "Profile link obtained (#{profile_link})"
          @profile_link = profile_link
        else
          fail Khcpl::NoProfileLinkFound, 'Profile link has not been found'
        end
      end

      def get_user_id
        user_id = @profile_link.scan(/\d/).join('')

        if user_id.present?
          Rails.logger.info "Profile ID obtained (#{user_id})"
          @user_id = user_id
        else
          fail Khcpl::NoUserIdFound, 'User id has not been found'
        end
      end
  end
end