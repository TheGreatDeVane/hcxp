module Hcxp
  class LinkParser

    # registers url handler for given pattern
    def self.register_url pattern, &block
      @patterns ||= {}
      @patterns[pattern] = block
    end

    def self.process_url url
      _, handler = @patterns.find{|p, _| url =~ p}
      if handler
        handler.call(url)
      else
        {}
      end
    end

  end
end

Dir[File.join(File.dirname(__FILE__), 'link_parsers', '*.rb')].each {|file| require file }