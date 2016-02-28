require 'rspec/its'
require 'rspec/react'
require 'rspec/as_fixture'

RSpec.describe 'HomePage', type: :component do
  context 'when addressing the world', :as_fixture do
    its(:content) { should include('Hello world') }
  end

  context 'when no props are given' do
    let(:props) { {} }

    its(:content) { should include('Hello you') }
  end

  context 'when invalid props are sent' do
    let(:props) { { name: -1 } }

    # It would be nice if React's PropTypes worked in a way that meant
    # I could capture props of incorrect types and raise errors for them
    # but I haven't yet figured out how to do this.
    xit { expect { rendered_component }.to raise_error(ArgumentError) }
  end
end
