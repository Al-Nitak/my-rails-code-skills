# frozen_string_literal: true

class V1::PageSettingsController < ApplicationController
  before_action :set_page_setting, only: %i(show)
  # GET /page_settings
  def index
    @home_page = format_to_hash(PageSetting.home_page)
    render json: @home_page
  end

  # GET /page_settings/1
  def show
    render(json: @page_setting)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_page_setting
    @page_setting = PageSetting.find(params[:id])
  end

  def format_to_hash(settings)
    hash = {}
    settings.each do |setting|
      hash.merge!(
        setting.key => {
          value: setting.value, attachment: setting.attachment_url(:large)
        },
      )
    end
    hash
  end
end
