require 'rubygems'
require 'mechanize'
require 'nokogiri'
require 'logger'
require 'erb'

module Khcpl
  module Exporters

    class Fhcpl

      def initialize
        # ID number of forum where events are posted
        @forum_id = ENV['KHCPL_EVENTS_FORUM_ID'].to_i

        # Mechanize agent
        @agent    = Mechanize.new
        # Uncomment to enter verbose mode
        # @agent.log = Logger.new $stderr
        @agent.user_agent_alias = 'Mac Safari'

        sign_in(
          ENV['KHCPL_EVENTS_USERNAME'],
          ENV['KHCPL_EVENTS_PASSWORD']
        )
      end

      def create(event = {})
        page = @agent.get("http://forum.hard-core.pl/posting.php?mode=post&f=#{@forum_id}")
        log 'New topic page loaded'

        # Format subject elements
        formatted_event = format_event(event)

        topic_form              = page.forms[1]
        topic_form.subject = formatted_event[:subject]
        topic_form.message = formatted_event[:message]
        log 'Filled topic form.'

        # phpbb bot-protection hack
        # see http://stackoverflow.com/q/23817583/552936
        log 'Waiting 2 seconds...'
        sleep 2

        page = @agent.submit(topic_form, topic_form.buttons[-6])
        log "Submited topic form"

        topic_url = page.search("//meta[@http-equiv='refresh']").last.attributes['content'].value
        topic_id  = topic_url.scan(/t=\d*/).last.scan(/\d/).join.to_i
        log "Topic ID obtained: #{topic_id}"

        topic_id
      end

      def destroy(topic_id)
        page = @agent.get("http://forum.hard-core.pl/viewtopic.php?f=#{@forum_id}&t=#{topic_id}")
        log 'Topic page loaded'

        quick_moderation_form = page.form_with(action: /mcp/)
        quick_moderation_form.field_with(name: 'action').option_with(value: 'delete_topic').click
        page = @agent.submit(quick_moderation_form)
        log 'Submited quick moderation form'

        confirm_form   = page.form_with(name: 'confirm')
        confirm_button = confirm_form.button_with(name: 'confirm')
        page = @agent.submit(confirm_form, confirm_button)
        log 'Submited confirmation form'

        log 'Topic removed!'
      end

      def update(topic_id, event)
        page = @agent.get("http://forum.hard-core.pl/viewtopic.php?f=#{@forum_id}&t=#{topic_id}")
        log 'Loaded topic page'

        edit_post_url = page.links_with(href: /mode=edit/).first.href
        post_id       = edit_post_url.scan(/p=\d*/).last.scan(/\d/).join.to_i

        page = @agent.get("http://forum.hard-core.pl/posting.php?mode=edit&f=#{@forum_id}&p=#{post_id}")
        log 'Loaded topic edit page'

        # Format subject elements
        formatted_event = format_event(event)

        edit_topic_form         = page.forms_with(name: 'postform').first
        edit_topic_form.subject = formatted_event[:subject]
        edit_topic_form.message = formatted_event[:message]

        # Set topic type based on event.is_promoted field.
        # If event is promoted, set it to 1 (sticky)
        # If event is not promoted, set it to 0 (normal)
        topic_type = event.is_promoted ? 1 : 0
        edit_topic_form.radiobutton_with(name: 'topic_type', value: topic_type.to_s).check

        submit_button = edit_topic_form.button_with(name: 'post')
        log 'Filled topic edit form'

        log 'Waiting 2 seconds...'
        sleep 2

        page = @agent.submit(edit_topic_form, submit_button)
        log 'Topic updated!'

        true
      end

      def format_event(event)
        {
          subject: format_subject(event),
          message: format_message(event)
        }
      end

      private

        def sign_in(user_name, password)
          page  = @agent.get('http://forum.hard-core.pl/ucp.php?mode=login') do |a|
            puts a
          end
          log 'Front page loaded.'

          sign_in_form          = page.forms[1]
          sign_in_form.username = user_name
          sign_in_form.password = password
          log 'Filled sign-in form.'

          page = @agent.submit(sign_in_form, sign_in_form.buttons.first)
          log "Submited sign-in form"

          if page.body.include? 'ucp.php?mode=logout'
            log 'Found log-out link'
            log 'Signed in successfully'
          else
            fail Khcpl::InvalidCredentials, 'Wrong username or password'
          end
        end

        def log(message)
          puts '-----> ' + message
        end

        def format_subject(event)
          city = event.venue ? event.venue.city : 'TBA'
          date = event.beginning_at.strftime('%d.%m/%y')
          rest = event.title_or_bands

          "#{city} [#{date}] #{rest}".truncate(60)
        end

        def format_message(event)
          ERB.new(File.read(File.dirname(__FILE__) + '/views/fhcpl.bbcode.erb')).result(binding)
          # event.description.present? ? event.description : Faker::Lorem.paragraph
        end
    end

  end
end