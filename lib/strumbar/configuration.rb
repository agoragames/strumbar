module Strumbar
  class Configuration
    attr_reader :port, :host, :application

    def port port
      @port = port
    end

    def host host
      @host = host
    end

    def application app
      @application = app
    end
  end
end
