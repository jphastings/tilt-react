require 'tilt/react/version'
require 'tilt'
require 'fileutils'
require 'json'
require 'v8'

module Tilt
  class ReactTemplate < Template
    def initialize(file=nil, line=1, options={}, &block)
      file = File.expand_path(file)
      @component_class = File.basename(file, '.jsx').split('_').map(&:capitalize).join
    end

    def evaluate(scope, props, &block)
      @output ||= begin
        component = @@renderer.renderToString(@component_class, props)
        %{<div data-react-class="#{@component_class}">#{component}</div><script data-react-class="#{@component_class}" type="application/json">#{props.to_json}</script>}
      end
    end

    def self.prepare_context
      @@context = V8::Context.new
      @@context.eval('window = {};')
    end

    def self.load_directory(glob)
      Dir.glob(glob).to_a.sort_by { |bundle|
        case bundle
        when %r{/tilt_react_client_bundle.js$} then 0
        when %r{/tilt_react_server_bundle.js$} then 1
        else 2
        end
      }.each do |bundle|
        @@context.load(bundle)
      end

      @@renderer = @@context.eval('window.TiltReact')
    end

    def self.file_to_class_name(file)
      File.basename(file, '.jsx').split('_').map(&:capitalize).join
    end

    def self.components
      @@context.eval('window.TiltReact.componentNames()').to_a
    end
  end
end

Tilt.register(Tilt::ReactTemplate, 'jsx')
