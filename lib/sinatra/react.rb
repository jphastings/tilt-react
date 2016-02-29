require 'sinatra/base'
require 'tilt/react'

module Sinatra
  module React
    module Helpers
      def react(*args)
        render :jsx, *args
      end

      def find_template(views, name, engine, &block)
        if engine == Tilt::ReactTemplate
          views = settings.components
        end
        super(views, name, engine, &block)
      end
    end

    def self.registered(app)
      app.helpers(Helpers)
      app.set :components, Proc.new { root && File.join(root, 'components') }
      app.set :js_libs, Proc.new { root && File.join(root, 'node_modules') }
      app.set :component_bundles, { '*.jsx' => 'js/components.js' }
      app.set :jsx, layout_engine: :erb

      app.configure do |config|
        # FIXME: I don't like this following line. Apparently this block gets called
        # multiple times, once without the settings above returning nil, and a second
        # time with them being what they should be. Because this block configures the
        # JS context calling it without js_libs means no libraries are loaded, so we
        # must wait until js_libs has content. 
        next unless config.settings.js_libs

        Tilt::ReactTemplate.js_libs = config.settings.js_libs
        Tilt::ReactTemplate.load_context
        Tilt::ReactTemplate.compile_bundles(config.settings.component_bundles.map { |glob, bundle|
          [
            File.expand_path(glob, config.settings.components),
            File.expand_path(bundle, config.settings.public_folder)
          ]
        })
      end
    end
  end

  register React
end
