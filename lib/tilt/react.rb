require 'tilt/react/version'
require 'tilt'
require 'fileutils'
require 'commonjs'
require 'commonjs/require_string'
require 'json'
require 'v8'

module Tilt
  class ReactTemplate < Template
    def initialize(file=nil, line=1, options={}, &block)
      file = File.expand_path(file)
      @bundle = @@bundle_lookup[file]
      raise "The requested component has not be loaded, or does not exist: #{file}" unless @bundle
      @component_class = File.basename(file, '.jsx').split('_').map(&:capitalize).join
    end

    def evaluate(scope, props, &block)
      @output ||= begin
        component = @@tilt_react_js.render(@component_class, props)
        %{<div data-react-class="#{@component_class}">#{component}</div><script data-react-class="#{@component_class}" type="application/json">#{props.to_json}</script>}
      end
    end

    def self.context
      @@context
    end

    def self.js_libs=(js_dirs)
      # Expand the js_libs to be the root and all folders in it, because CommonJS.rb doesn't do this
      @js_libs = [*js_dirs].map { |dir|
        [
          dir,
          Dir.glob("#{dir}/*").select { |f| File.directory? f }
        ]
      }.flatten.compact
    end

    def self.load_context
      # Include the tilt-react bootstrap JS
      all_libs = @js_libs + [File.expand_path('../../ext/', __dir__)]

      @@context = CommonJS::Environment.new(
        V8::Context.new,
        path: all_libs
      ).tap { |env|
        env.runtime[:process] = { 'env' => ENV }
        @@tilt_react_js = env.require('tilt-react')
      }
    end

    def self.compile_bundles(bundles)
      bundles.each do |selector, target|
        files = case selector
        when Enumerable then selector
        when String then Dir.glob(selector)
        else raise "Cannot coerce into list of files: #{selector}"
        end

        if files.any?
          FileUtils.mkdir_p(File.dirname(target))

          compile(files).each do |file, es5|
            @@bundle_lookup[file] = target
          end
          
          # FIXME: Browserify the es5
          File.open(target, 'w') {}
        end
      end
    end

    def self.compile(files)
      @@bundle_lookup ||= {}

      [*files].map do |file|
        file = File.expand_path(file)
        next if @@bundle_lookup[file]

        export_as = file_to_class_name(file)
        template = Tilt::BabelTemplate.new(file)
        es5 = template.render
        @@tilt_react_js.components[export_as] = context.require_string(export_as, es5)
        @@bundle_lookup[file] = true
        [file, es5]
      end
    end

    private

    def self.file_to_class_name(file)
      File.basename(file, '.jsx').split('_').map(&:capitalize).join
    end
  end
end

Tilt.register(Tilt::ReactTemplate, 'jsx')
