require 'tilt/react'
require 'capybara/rspec'

module RSpec
  module React
    class << self
      attr_writer :js_libs, :components

      def js_libs
        @js_libs || 'node_modules'
      end

      def components
        @components || 'components'
      end
    end

    module ComponentHelpers
      def self.included(klass)
        include Capybara::RSpecMatchers

        Tilt::ReactTemplate.load_context(RSpec::React.js_libs)

        klass.around do |example|
          group = example.metadata[:example_group]
          loop do
            break if group[:parent_example_group].nil?
            group = group[:parent_example_group]
          end

          component = group[:description]
          snake_cased = component.gsub(/::/, '/').
            gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
            gsub(/([a-z\d])([A-Z])/,'\1_\2').
            tr("-", "_").
            downcase
          filename = File.expand_path("#{snake_cased}.jsx", RSpec::React.components)

          Tilt::ReactTemplate.compile(filename)
          @template = Tilt::ReactTemplate.new(filename)
          
          example.run
        end

        klass.subject(:rendered_component) { html_from_component(props) }
      end

      # Renders the component defined in the describe block using the given props blob.
      #
      # This returns a Nokogiri element, so you can do the following to make your tests clean:
      #
      #     let(:props) { { name: 'JP' } }
      #     subject { html_from_component(props) }
      #     its(:content) { should include('JP') }
      #
      # @return [Nokogiri::XML::Element] The (necessarily singular) root HTML element that the component returns as a parsed XML object
      def html_from_component(props = {})
        fragment = Nokogiri::HTML.fragment(@template.render(nil, props))

        # React components can only ever have one top-level element, so we just return that
        fragment.children.first
      end
    end
  end
end