# Test the API binding used to download Foreman instance
require 'json'

require 'foregit'
require 'foreman/api'
require 'spec_helper'

describe Foreman::Api do

  before (:each) do
    # Create settings and ensure the resources is set to :architectures
    @settings = attributes_for(:settings)
    @settings[:resources] = :architectures

    # Mock Foreman API response
    @binding = Foreman::Api.new @settings
    allow(@binding.api).to receive(:call).and_return(build(:architectures).to_json)

  end

  describe '#download_resources' do

    context 'download resources defined in settings file' do
      it 'should return a hash with :architectures' do
        downloaded_resources = @binding.download_resources
        expect(downloaded_resources).to be_an_instance_of(Hash)
        expect(downloaded_resources).to have_key(:architectures)
      end
    end

    context 'download resources passed as arguments' do
      it 'should return a hash with :hosts_groups' do
        downloaded_resources = @binding.download_resources(:hosts_groups)
        expect(downloaded_resources).to be_an_instance_of(Hash)
        expect(downloaded_resources).to have_key(:hosts_groups)
      end
    end

    context 'download resources raises error when no resource is set' do
      it 'should raise ArgumentError' do
        # Ensure no resources are set to be downloaded from Foreman
        @settings.delete(:resources)
        @binding = Foreman::Api.new @settings
        allow(@binding.api).to receive(:call).and_return(build(:architectures).to_json)
        expect{@binding.download_resources}.to raise_error(ArgumentError)
      end
    end

  end

end
