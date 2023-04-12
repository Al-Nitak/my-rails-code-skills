# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EducationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/educations').to route_to('educations#index')
    end

    it 'routes to #show' do
      expect(get: '/educations/1').to route_to('educations#show', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/educations').to route_to('educations#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/educations/1').to route_to('educations#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/educations/1').to route_to('educations#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/educations/1').to route_to('educations#destroy', id: '1')
    end
  end
end
