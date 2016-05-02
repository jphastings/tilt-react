require 'sinatra/base'
require 'tilt/react'
require 'rack/accept'

module Sinatra
  module React
    module Helpers
      def react(component, opts = {})
        req = Rack::Accept::MediaType.new(request.env['HTTP_ACCEPT'])
        if req.accept?('text/html')
          return render :jsx, component, opts
        elsif req.accept?('application/json')
          content_type :json
          return json_for_props(component, opts[:locals])
        else
          halt 406
        end
      end

      def find_template(views, name, engine, &block)
        if engine == Tilt::ReactTemplate
          views = Tilt::ReactTemplate.components
        end
        super(views, name, engine, &block)
      end

      private

      def json_for_props(component, props)
        [
          Tilt::ReactTemplate.file_to_class_name(component.to_s),
          props
        ].to_json
      end
    end

    def self.registered(app)
      app.helpers(Helpers)
      app.set :bundles_glob, 'public/js/*_bundle.js'
      app.set :jsx, layout_engine: :erb

      app.configure do |config|
        Tilt::ReactTemplate.prepare_context
        Tilt::ReactTemplate.load_directory(config.settings.bundles_glob)
      end
    end
  end

  register React
end
