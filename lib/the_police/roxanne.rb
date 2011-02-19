require 'set'
require 'rack/request'

module ThePolice
  class Roxanne
    TEN_MEGABYTES = 10485760
    WATCH_FOR     = [500]
    
    attr_reader :app, :collection, :watch_for
    
    def initialize(app, options)
      raise "Roxanne needs connections!" unless options[:connection]
      connection = options[:connection].respond_to?(:call) ?
                      options[:connection].call :
                      options[:connection]
      
      @app = app
      @collection = connection.create_collection(
          options[:collection] || 'messages-in-bottles',
          :capped => true,
          :size   => options[:capsize] || TEN_MEGABYTES)
      
      @watch_for = Set.new(options[:watch_for] || WATCH_FOR)
    end
    
    def call(env)
      @app.call(env).tap do |result|
        if watch_for.include?(result.first)
          log(env, result)
        end
      end
    end
    
    def log(env, result)
      request = Rack::Request.new(env)
      collection.insert({
        "level"         => "error",
        "type"          => "request",
        "time"          => Time.now.utc,
        "data"          => {
          "method"        => request.request_method,
          "url"           => request.url,
          "params"        => request.params,
          "response_body" => result.last.size == 1 && result.last[0].kind_of?(String) ? result.last[0] : "IO Stream",          
        }
      }, {"safe" => false})
    rescue StandardError => e
      puts "Error #{e} - #{e.backtrace}"
      # Lets make sure logging an error doesn't break stuff!
    end
  end
end